class User < ApplicationRecord
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

  private

  def send_updates_to_admin
    # Only send email if one of the specified fields changed
    monitored_fields = %w[
      first_name last_name passport_number email nie_number date_of_birth expiry_date
      mobile_phone full_name_on_passport nationality profession marital_status spouse 
      mailing_address mother_s_first_name father_s_first_name r_origin_bank_details 
      otb_origin_bank_details balance_bank_details standing_orders_bank_details 
      here_till name_of_present_spouse name_of_the_previous_spouses date_of_divorce 
      date_of_decease needs_poa tax_resident father_s_full_name father_s_vital_status 
      mother_s_full_name mother_s_vital_status children outline_of_bequests_and_oder_of_success 
      inheritance_to_be_governed_by poa_made_in_spain poa_for home_address currency needs_nie 
      needs_mortgage wants_to_holiday_let has_a_spanish_bank_account b_preferred_notary_date 
      buying_property_address selling_property_address requested_services 
      energy_efficiency_certificate_cee
    ]
    # previous_changes is available in after_commit
    changed = previous_changes.keys & monitored_fields
    return if changed.empty?

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
  end
end
