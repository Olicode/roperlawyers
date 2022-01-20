class ApplicationController < ActionController::Base
  def after_sign_in_path_for(resource)
    edit_user_path(resource)
  end

  def sf_attrs_map(user)
    {
      FirstName: user.first_name,
      LastName: user.last_name || user.email,
      Email: user.email,
      Passport_Number__c: user.passport_number,
      NIE_Number__c: user.nie_number,
      Date_of_Birth__c: user.date_of_birth,
      Expiry_Date__c: user.expiry_date
    }
  end
end
