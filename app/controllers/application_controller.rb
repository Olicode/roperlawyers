class ApplicationController < ActionController::Base
  def after_sign_in_path_for(resource)
    edit_user_path(resource)
  end

  def sf_attrs_map(user)
    {
      FirstName: user.first_name,
      LastName: user.last_name || user.email,
      Email: user.email,
      MobilePhone: user.mobile_phone,
      Full_name_on_passport__c: user.full_name_on_passport,
      Passport_Number__c: user.passport_number,
      Date_of_Birth__c: user.date_of_birth,
      Expiry_Date__c: user.expiry_date,
      Nationality__c: user.nationality,
      Profesi_n__c: user.profession,
      Estado_Civil__c: user.marital_status,
      Here_till__c: user.here_till,
      NIE_Number__c: user.nie_number,
      Father_s_First_Name__c: user.father_s_first_name,
      Mother_s_First_Name__c: user.mother_s_first_name,
      R_origin_Bank_details__c: user.r_origin_bank_details,
      OTB_origin_Bank_details__c: user.otb_origin_bank_details,
      Balance_Bank_details__c: user.balance_bank_details,
      Standing_orders_Bank_details__c: user.standing_orders_bank_details
    }
  end

  def sf_file_upload_attrs_map(user, document, doc_type)
    {
      Name: "#{doc_type} #{user.first_name} #{user.last_name}",
      ParentId: user.sf_contact_id,
      description: "Uploaded by #{user.first_name} #{user.last_name}",
      Body: Base64::encode64(File.read(document))
    }
  end
end

