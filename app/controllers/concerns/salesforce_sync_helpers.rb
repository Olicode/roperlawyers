# frozen_string_literal: true

module SalesforceSyncHelpers
  extend ActiveSupport::Concern

  def sf_file_upload_attrs_map(user, document, doc_type)
    file_data = if document.respond_to?(:tempfile)
                  File.read(document.tempfile.path)
                else
                  File.read(document.path)
                end

    {
      convent_version: {
        Title: "#{doc_type} #{user.first_name} #{user.last_name}",
        PathOnClient: document.original_filename,
        VersionData: Base64::encode64(file_data)
      },
      content_document_link: {
        LinkedEntityId: user.sf_contact_id,
        ShareType: 'V'
      }
    }
  end
end
