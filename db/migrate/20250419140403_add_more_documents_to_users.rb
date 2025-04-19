class AddMoreDocumentsToUsers < ActiveRecord::Migration[7.1]
  def change
    # No need to add columns since Active Storage handles attachments
    # This migration is for documentation purposes
    # The attachments are defined in the User model with has_many_attached for:
    # - municipal_certificate_documents
    # - property_tax_receipt_documents
    # - floor_plan_documents
    # - community_approval_documents
  end
end
