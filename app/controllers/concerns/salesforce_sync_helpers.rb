# frozen_string_literal: true

module SalesforceSyncHelpers
  extend ActiveSupport::Concern

  def sf_attrs_map(user)
    {
      FirstName: user.first_name,
      LastName: user.last_name || user.email,
      Email: user.email,
      MobilePhone: user.mobile_phone,
      Full_name_on_passport__c: user.full_name_on_passport,
      Passport_Number__c: user.passport_number,
      Date_of_Birth__c: user.date_of_birth&.iso8601,
      Expiry_Date__c: user.expiry_date&.iso8601,
      Nationality__c: user.nationality,
      Profesi_n__c: user.profession,
      Estado_Civil__c: user.marital_status,
      Spouse__c: user.spouse,
      Home_Address_del__c: user.home_address,
      Buying_Property_Address__c: user.buying_property_address,
      Selling_Property_Address__c: user.selling_property_address,
      Father_s_First_Name__c: user.father_s_first_name,
      Mother_s_First_Name__c: user.mother_s_first_name,
      R_Origin_Bank_Details__c: user.r_origin_bank_details,
      OTB_Origin_Bank_Details__c: user.otb_origin_bank_details,
      Balance_Bank_Details__c: user.balance_bank_details,
      Standing_Orders_Bank_Details__c: user.standing_orders_bank_details,
      Needs_PoA__c: user.needs_poa,
      Here_Till__c: user.here_till,
      Date_of_decease__c: user.date_of_decease&.iso8601,
      Father_s_Full_Name__c: user.father_s_full_name,
      Father_s_Vital_Status__c: user.father_s_vital_status,
      Mother_s_Full_Name__c: user.mother_s_full_name,
      Mother_s_Vital_Status__c: user.mother_s_vital_status,
      Children__c: user.children,
      Outline_of_bequests_and_order_of_success__c: user.outline_of_bequests_and_oder_of_success,
      Inheritance_to_be_governed_by__c: user.inheritance_to_be_governed_by,
      Energy_Efficiency_Certificate_CEE__c: user.energy_efficiency_certificate_cee,
      Escritura__c: user.escritura,
      Wants_to_holiday_let__c: user.wants_to_holiday_let,
      NIE_Number__c: user.nie_number,
      Name_of_the_present_spouse__c: user.name_of_the_present_spouse,
      Name_of_the_previous_spouses__c: user.name_of_the_previous_spouses,
      Date_of_divorce__c: user.date_of_divorce&.iso8601,
      Tax_Resident__c: user.tax_resident ? 'Yes' : 'No',
      PoA_made_in_Spain__c: user.poa_made_in_spain == 'yes' ? 'Yes' : 'No',
      PoA_for__c: user.salesforce_poa_for,
      Currency__c: user.currency,
      Needs_NIE__c: user.needs_nie == 'yes' ? 'Yes' : 'No',
      Needs_Mortgage__c: user.needs_mortgage,
      Has_a_Spanish_Bank_Account__c: user.has_a_spanish_bank_account == 'yes' ? 'Yes' : 'No',
      B_Preferred_Notary_date__c: user.b_preferred_notary_date&.iso8601,
      Requested_Services__c: user.salesforce_requested_services,
      FX_Quote_Referral_Consent__c: user.fx_quote_referral_consent? ? 'Yes' : 'No',
    }
  end

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
