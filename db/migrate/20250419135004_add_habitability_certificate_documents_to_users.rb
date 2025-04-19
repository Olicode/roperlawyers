class AddHabitabilityCertificateDocumentsToUsers < ActiveRecord::Migration[7.1]
  def change
    # No need to add columns since Active Storage handles attachments
    # This migration is for documentation purposes
    # The attachment is defined in the User model with has_many_attached :habitability_certificate_documents
  end
end
