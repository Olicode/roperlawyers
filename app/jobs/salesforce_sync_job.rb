class SalesforceSyncJob < ApplicationJob
  include SalesforceSyncHelpers
  queue_as :default

  def perform(user)
    if user.sf_contact_id.blank?
      sf_contact_id = SalesforceService.create_or_update_contact(SalesforceAdapter.adapt_to(user))
      user.update!(sf_contact_id: sf_contact_id) unless sf_contact_id == false
    else
      SalesforceService.update_contact(SalesforceAdapter.adapt_to(user).merge!(Id: user.sf_contact_id))

      if user.nie_document.attached?
        SalesforceService.upload_file(sf_file_upload_attrs_map(user, user.nie_document, "NIE"))
      end

      if user.passport_document.attached?
        SalesforceService.upload_file(sf_file_upload_attrs_map(user, user.passport_document, "Passport"))
      end

      if user.igic_registration_modelo_400_document.attached?
        SalesforceService.upload_file(sf_file_upload_attrs_map(user, user.igic_registration_modelo_400_document, "IGIC Registration Modelo 400"))
      end

      user.nota_simple_documents.each do |document|
        begin
          Rails.logger.info "Uploading Nota Simple document: #{document.inspect}"
          SalesforceService.upload_file(sf_file_upload_attrs_map(user, document, "Nota Simple"))
          Rails.logger.info "Successfully uploaded Nota Simple document"
        rescue => e
          Rails.logger.error "Error uploading Nota Simple document: #{e.message}"
          Rails.logger.error e.backtrace.join("\n")
        end
      end

      user.title_deed_documents.each do |document|
        begin
          Rails.logger.info "Uploading Title Deed document: #{document.inspect}"
          SalesforceService.upload_file(sf_file_upload_attrs_map(user, document, "Title Deed"))
          Rails.logger.info "Successfully uploaded Title Deed document"
        rescue => e
          Rails.logger.error "Error uploading Title Deed document: #{e.message}"
          Rails.logger.error e.backtrace.join("\n")
        end
      end

      user.vv_license_documents.each do |document|
        SalesforceService.upload_file(sf_file_upload_attrs_map(user, document, "VV License"))
      end

      user.first_occupation_license_documents.each do |document|
        SalesforceService.upload_file(sf_file_upload_attrs_map(user, document, "First Occupation License"))
      end

      user.cee_documents.each do |document|
        SalesforceService.upload_file(sf_file_upload_attrs_map(user, document, "CEE"))
      end

      user.civil_liability_insurance_policy_documents.each do |document|
        SalesforceService.upload_file(sf_file_upload_attrs_map(user, document, "Civil Liability Insurance Policy"))
      end

      user.habitability_certificate_documents.each do |document|
        SalesforceService.upload_file(sf_file_upload_attrs_map(user, document, "Habitability Certificate"))
      end

      user.municipal_certificate_documents.each do |document|
        SalesforceService.upload_file(sf_file_upload_attrs_map(user, document, "Municipal Certificate"))
      end

      user.property_tax_receipt_documents.each do |document|
        SalesforceService.upload_file(sf_file_upload_attrs_map(user, document, "Property Tax Receipt (IBI)"))
      end

      user.floor_plan_documents.each do |document|
        SalesforceService.upload_file(sf_file_upload_attrs_map(user, document, "Floor Plan"))
      end

      user.community_approval_documents.each do |document|
        SalesforceService.upload_file(sf_file_upload_attrs_map(user, document, "Community Approval"))
      end

      user.water_bill_documents.each do |document|
        SalesforceService.upload_file(sf_file_upload_attrs_map(user, document, "Water Bill"))
      end

      user.electricity_bill_documents.each do |document|
        SalesforceService.upload_file(sf_file_upload_attrs_map(user, document, "Electricity Bill"))
      end
    end
  end
end
