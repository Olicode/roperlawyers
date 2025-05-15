class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  
  validates :email, presence: true
  validates :last_name, presence: true, on: :update

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
  #after_create_commit :send_updates_to_admin
  after_update_commit :send_updates_to_admin


  def full_name
    "#{first_name} #{last_name}"
  end

  private

  def send_updates_to_admin
    puts "*" * 100
    puts "sending email to admin"
    puts "*" * 100
    # TODO: uncomment when sendgrid email starts working.
    AdminMailer.send_user_updates(self).deliver_now
  end
end
