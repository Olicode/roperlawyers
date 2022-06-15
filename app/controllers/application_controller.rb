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
      Needs_PoA__c: user.needs_poa,
      NIE_Number__c: user.nie_number,
      Father_s_First_Name__c: user.father_s_first_name,
      Mother_s_First_Name__c: user.mother_s_first_name,
      R_origin_Bank_details__c: user.r_origin_bank_details,
      OTB_origin_Bank_details__c: user.otb_origin_bank_details,
      Balance_Bank_details__c: user.balance_bank_details,
      Standing_orders_Bank_details__c: user.standing_orders_bank_details,
      Name_of_the_present_spouse__c: user.name_of_the_present_spouse,
      Name_of_the_previous_spouses__c: user.name_of_the_previous_spouses,
      Date_of_divorce__c: user.date_of_divorce,
      Date_of_decease__c: user.date_of_decease,
      Father_s_Full_Name__c: user.father_s_full_name,
      Father_s_Vital_Status__c: user.father_s_vital_status,
      Mother_s_Full_Name__c: user.mother_s_full_name,
      Mother_s_Vital_Status__c: user.mother_s_vital_status,
      Children__c: user.children,
      Outline_of_bequests_and_order_of_success__c: user.outline_of_bequests_and_oder_of_success,
      Inheritance_to_be_governed_by__c: user.inheritance_to_be_governed_by,
      PoA_made_in_Spain__c: user.poa_made_in_spain,
      PoA_for__c: user.poa_for
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
