class User < ApplicationRecord
  include UserFieldDefinitions
  
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
  after_commit :send_updates_to_admin, on: [:update]
  
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
    
    # Use background job for better performance and error handling
    SalesforceSyncJob.perform_later(self)
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
