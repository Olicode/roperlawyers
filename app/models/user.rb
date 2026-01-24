class User < ApplicationRecord
  include UserFieldDefinitions
  include SalesforceSyncHelpers
  
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  
  validates :email, presence: true
  validates :first_name, :last_name, :mobile_phone, presence: true, on: :update

  has_one_attached :nie_document
  has_one_attached :passport_document
  has_one_attached :igic_registration_modelo_400_document
  has_many_attached :nota_simple_documents
  has_many_attached :title_deed_documents
  has_many_attached :vv_license_documents
  has_many_attached :first_occupation_license_documents
  has_many_attached :cee_documents
  has_many_attached :civil_liability_insurance_policy_documents
  has_many_attached :habitability_certificate_documents
  has_many_attached :municipal_certificate_documents
  has_many_attached :property_tax_receipt_documents
  has_many_attached :floor_plan_documents
  has_many_attached :community_approval_documents
  has_many_attached :water_bill_documents
  has_many_attached :electricity_bill_documents

  # These callbacks will send emails to info@roperlawyers.com
  after_commit :send_updates_to_admin, on: [:create, :update]
  
  # Salesforce sync callbacks
  after_commit :sync_with_salesforce, on: [:create, :update]

  def full_name
    "#{first_name} #{last_name}"
  end

  def salesforce_poa_for
    case poa_for
    when "buying"
      "Buying"
    when "selling"
      "Selling"
    when "both"
      "Buying & Selling"
    when "all"
      "Buying, Selling & Mortgage"
    end
  end

  def salesforce_requested_services
    return "" unless requested_services && requested_services.is_a?(String)

    JSON.parse(requested_services)&.join(";")
  end

  private

  def sync_with_salesforce
    # Only sync if we have the minimum required fields for Salesforce
    return unless email.present? && (first_name.present? || last_name.present?)
    
    # Perform sync immediately (synchronously) to ensure files are properly handled
    # Background jobs can't serialize file attachments properly
    begin
      if sf_contact_id.blank?
        new_sf_contact_id = SalesforceService.create_or_update_contact(SalesforceAdapter.adapt_to(self))
        update_column(:sf_contact_id, new_sf_contact_id) unless new_sf_contact_id == false
      else
        SalesforceService.update_contact(SalesforceAdapter.adapt_to(self).merge!(Id: sf_contact_id))
      end
      
      # Upload documents if attached
      sync_documents_to_salesforce
    rescue => e
      Rails.logger.error "Salesforce sync failed for user #{id}: #{e.message}"
      Rails.logger.error e.backtrace.first(5).join("\n")
      # Don't re-raise - allow form submission to succeed
    end
  end
  
  def sync_documents_to_salesforce
    # Single file attachments
    [
      { attachment: nie_document, label: "NIE" },
      { attachment: passport_document, label: "Passport" },
      { attachment: igic_registration_modelo_400_document, label: "IGIC Registration Modelo 400" }
    ].each do |doc|
      if doc[:attachment].attached?
        begin
          SalesforceService.upload_file(sf_file_upload_attrs_map(self, doc[:attachment], doc[:label]))
        rescue => e
          Rails.logger.error "Error uploading #{doc[:label]}: #{e.message}"
        end
      end
    end
    
    # Multiple file attachments
    [
      { attachments: nota_simple_documents, label: "Nota Simple" },
      { attachments: title_deed_documents, label: "Title Deed" },
      { attachments: vv_license_documents, label: "VV License" },
      { attachments: first_occupation_license_documents, label: "First Occupation License" },
      { attachments: cee_documents, label: "CEE" },
      { attachments: civil_liability_insurance_policy_documents, label: "Civil Liability Insurance Policy" },
      { attachments: habitability_certificate_documents, label: "Habitability Certificate" },
      { attachments: municipal_certificate_documents, label: "Municipal Certificate" },
      { attachments: property_tax_receipt_documents, label: "Property Tax Receipt (IBI)" },
      { attachments: floor_plan_documents, label: "Floor Plan" },
      { attachments: community_approval_documents, label: "Community Approval" },
      { attachments: water_bill_documents, label: "Water Bill" },
      { attachments: electricity_bill_documents, label: "Electricity Bill" }
    ].each do |doc_group|
      doc_group[:attachments].each do |document|
        begin
          SalesforceService.upload_file(sf_file_upload_attrs_map(self, document, doc_group[:label]))
        rescue => e
          Rails.logger.error "Error uploading #{doc_group[:label]}: #{e.message}"
        end
      end
    end
  end

  def send_updates_to_admin
    # Only send email if one of the specified fields changed
    monitored_fields = UserFieldDefinitions.all_field_names
    # previous_changes is available in after_commit
    changed = previous_changes.keys & monitored_fields
    return if changed.empty?

    begin
      if previous_changes.keys.include?("id")
        # Always send on create
        AdminMailer.send_user_updates(self).deliver_now
        update_column(:last_admin_update_sent_at, Time.current)
      else
        # Throttle for updates only
        if last_admin_update_sent_at.nil? || last_admin_update_sent_at < 1.hour.ago
          AdminMailer.send_user_updates(self).deliver_now
          update_column(:last_admin_update_sent_at, Time.current)
        end
      end
    rescue => e
      # Log the error but don't break the form submission
      Rails.logger.error "Failed to send admin update email: #{e.message}"
      # Optionally, you could store this in a failed jobs queue or send to an error tracking service
    end
  end
end
