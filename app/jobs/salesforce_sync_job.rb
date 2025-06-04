class SalesforceSyncJob < ApplicationJob
  include SalesforceSyncHelpers
  queue_as :default

  def perform(user_id, user_params)
    user = User.find(user_id)
    # Rebuild symbolized keys for user_params if needed
    user_params = user_params.with_indifferent_access

    if user.sf_contact_id.blank?
      sf_contact_id = SalesforceService.create_or_update_contact(sf_attrs_map(user))
      user.update!(sf_contact_id: sf_contact_id) unless sf_contact_id == false
    else
      SalesforceService.update_contact(sf_attrs_map(user).merge!(Id: user.sf_contact_id))

      if user_params[:nie_document].present?
        SalesforceService.upload_file(sf_file_upload_attrs_map(user, user_params[:nie_document], "NIE"))
      end

      if user_params[:passport_document].present?
        SalesforceService.upload_file(sf_file_upload_attrs_map(user, user_params[:passport_document], "Passport"))
      end

      if user_params[:igic_registration_modelo_400_document].present?
        SalesforceService.upload_file(sf_file_upload_attrs_map(user, user_params[:igic_registration_modelo_400_document], "IGIC Registration Modelo 400"))
      end

      if user_params[:nota_simple_documents]&.reject(&:blank?)&.present?
        user_params[:nota_simple_documents].reject(&:blank?).each do |document|
          begin
            Rails.logger.info "Uploading Nota Simple document: #{document.inspect}"
            SalesforceService.upload_file(sf_file_upload_attrs_map(user, document, "Nota Simple"))
            Rails.logger.info "Successfully uploaded Nota Simple document"
          rescue => e
            Rails.logger.error "Error uploading Nota Simple document: #{e.message}"
            Rails.logger.error e.backtrace.join("\n")
          end
        end
      end

      if user_params[:title_deed_documents]&.reject(&:blank?)&.present?
        user_params[:title_deed_documents].reject(&:blank?).each do |document|
          begin
            Rails.logger.info "Uploading Title Deed document: #{document.inspect}"
            SalesforceService.upload_file(sf_file_upload_attrs_map(user, document, "Title Deed"))
            Rails.logger.info "Successfully uploaded Title Deed document"
          rescue => e
            Rails.logger.error "Error uploading Title Deed document: #{e.message}"
            Rails.logger.error e.backtrace.join("\n")
          end
        end
      end

      if user_params[:vv_license_documents]&.reject(&:blank?)&.present?
        user_params[:vv_license_documents].reject(&:blank?).each do |document|
          SalesforceService.upload_file(sf_file_upload_attrs_map(user, document, "VV License"))
        end
      end

      if user_params[:first_occupation_license_documents]&.reject(&:blank?)&.present?
        user_params[:first_occupation_license_documents].reject(&:blank?).each do |document|
          SalesforceService.upload_file(sf_file_upload_attrs_map(user, document, "First Occupation License"))
        end
      end

      if user_params[:cee_documents]&.reject(&:blank?)&.present?
        user_params[:cee_documents].reject(&:blank?).each do |document|
          SalesforceService.upload_file(sf_file_upload_attrs_map(user, document, "CEE"))
        end
      end

      if user_params[:civil_liability_insurance_policy_documents]&.reject(&:blank?)&.present?
        user_params[:civil_liability_insurance_policy_documents].reject(&:blank?).each do |document|
          SalesforceService.upload_file(sf_file_upload_attrs_map(user, document, "Civil Liability Insurance Policy"))
        end
      end

      if user_params[:habitability_certificate_documents]&.reject(&:blank?)&.present?
        user_params[:habitability_certificate_documents].reject(&:blank?).each do |document|
          SalesforceService.upload_file(sf_file_upload_attrs_map(user, document, "Habitability Certificate"))
        end
      end

      if user_params[:municipal_certificate_documents]&.reject(&:blank?)&.present?
        user_params[:municipal_certificate_documents].reject(&:blank?).each do |document|
          SalesforceService.upload_file(sf_file_upload_attrs_map(user, document, "Municipal Certificate"))
        end
      end

      if user_params[:property_tax_receipt_documents]&.reject(&:blank?)&.present?
        user_params[:property_tax_receipt_documents].reject(&:blank?).each do |document|
          SalesforceService.upload_file(sf_file_upload_attrs_map(user, document, "Property Tax Receipt (IBI)"))
        end
      end

      if user_params[:floor_plan_documents]&.reject(&:blank?)&.present?
        user_params[:floor_plan_documents].reject(&:blank?).each do |document|
          SalesforceService.upload_file(sf_file_upload_attrs_map(user, document, "Floor Plan"))
        end
      end

      if user_params[:community_approval_documents]&.reject(&:blank?)&.present?
        user_params[:community_approval_documents].reject(&:blank?).each do |document|
          SalesforceService.upload_file(sf_file_upload_attrs_map(user, document, "Community Approval"))
        end
      end

      if user_params[:water_bill_documents]&.reject(&:blank?)&.present?
        user_params[:water_bill_documents].reject(&:blank?).each do |document|
          SalesforceService.upload_file(sf_file_upload_attrs_map(user, document, "Water Bill"))
        end
      end

      if user_params[:electricity_bill_documents]&.reject(&:blank?)&.present?
        user_params[:electricity_bill_documents].reject(&:blank?).each do |document|
          SalesforceService.upload_file(sf_file_upload_attrs_map(user, document, "Electricity Bill"))
        end
      end
    end
  end
end
