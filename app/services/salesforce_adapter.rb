# frozen_string_literal: true

class SalesforceAdapter
  # Centralized field mapping configuration
  # Format: user_field => { sf_field: 'SalesforceField__c', transform: proc }
  FIELD_MAPPINGS = {
    first_name: { sf_field: 'FirstName' },
    last_name: { sf_field: 'LastName', transform: ->(user, value) { value || user.email } },
    email: { sf_field: 'Email' },
    mobile_phone: { sf_field: 'MobilePhone' },
    full_name_on_passport: { sf_field: 'Full_name_on_passport__c' },
    passport_number: { sf_field: 'Passport_Number__c' },
    date_of_birth: { 
      sf_field: 'Date_of_Birth__c',
      to_sf: ->(value) { value&.iso8601 },
      from_sf: ->(value) { value }
    },
    place_of_birth: { sf_field: 'Place_of_Birth__c' },
    expiry_date: { 
      sf_field: 'Expiry_Date__c',
      to_sf: ->(value) { value&.iso8601 },
      from_sf: ->(value) { value }
    },
    nationality: { sf_field: 'Nationality__c' },
    profession: { sf_field: 'Profesi_n__c' },
    marital_status: { sf_field: 'Estado_Civil__c' },
    spouse: { sf_field: 'Spouse__c' },
    home_address: { sf_field: 'Home_Address_del__c' },
    buying_property_address: { sf_field: 'Buying_Property_Address__c' },
    selling_property_address: { sf_field: 'Selling_Property_Address__c' },
    father_s_first_name: { sf_field: 'Father_s_First_Name__c' },
    mother_s_first_name: { sf_field: 'Mother_s_First_Name__c' },
    r_origin_bank_details: { sf_field: 'R_Origin_Bank_Details__c' },
    otb_origin_bank_details: { sf_field: 'OTB_Origin_Bank_Details__c' },
    balance_bank_details: { sf_field: 'Balance_Bank_Details__c' },
    standing_orders_bank_details: { sf_field: 'Standing_Orders_Bank_Details__c' },
    needs_poa: { sf_field: 'Needs_PoA__c' },
    here_till: { sf_field: 'Here_Till__c' },
    date_of_decease: { 
      sf_field: 'Date_of_decease__c',
      to_sf: ->(value) { value&.iso8601 },
      from_sf: ->(value) { value }
    },
    father_s_full_name: { sf_field: 'Father_s_Full_Name__c' },
    father_s_vital_status: { sf_field: 'Father_s_Vital_Status__c' },
    mother_s_full_name: { sf_field: 'Mother_s_Full_Name__c' },
    mother_s_vital_status: { sf_field: 'Mother_s_Vital_Status__c' },
    children: { sf_field: 'Children__c' },
    outline_of_bequests_and_oder_of_success: { sf_field: 'Outline_of_bequests_and_order_of_success__c' },
    inheritance_to_be_governed_by: { sf_field: 'Inheritance_to_be_governed_by__c' },
    energy_efficiency_certificate_cee: { sf_field: 'Energy_Efficiency_Certificate_CEE__c' },
    escritura: { sf_field: 'Escritura__c' },
    wants_to_holiday_let: { sf_field: 'Wants_to_holiday_let__c' },
    nie_number: { sf_field: 'NIE_Number__c' },
    name_of_the_present_spouse: { sf_field: 'Name_of_the_present_spouse__c' },
    name_of_the_previous_spouses: { sf_field: 'Name_of_the_previous_spouses__c' },
    date_of_divorce: { 
      sf_field: 'Date_of_divorce__c',
      to_sf: ->(value) { value&.iso8601 },
      from_sf: ->(value) { value }
    },
    tax_resident: { 
      sf_field: 'Tax_Resident__c',
      to_sf: ->(value) { value ? 'Yes' : 'No' },
      from_sf: ->(value) { value == 'Yes' || value == true || false }
    },
    poa_made_in_spain: { 
      sf_field: 'PoA_made_in_Spain__c',
      to_sf: ->(value) { value == 'yes' ? 'Yes' : 'No' },
      from_sf: ->(value) { value }
    },
    poa_for: { 
      sf_field: 'PoA_for__c',
      to_sf: ->(user, _value) { user.salesforce_poa_for },
      from_sf: ->(value) { value }
    },
    currency: { sf_field: 'Currency__c' },
    needs_nie: { 
      sf_field: 'Needs_NIE__c',
      to_sf: ->(value) { value == 'yes' ? 'Yes' : 'No' },
      from_sf: ->(value) { value }
    },
    needs_mortgage: { sf_field: 'Needs_Mortgage__c' },
    has_a_spanish_bank_account: { 
      sf_field: 'Has_a_Spanish_Bank_Account__c',
      to_sf: ->(value) { value == 'yes' ? 'Yes' : 'No' },
      from_sf: ->(value) { value }
    },
    b_preferred_notary_date: { 
      sf_field: 'B_Preferred_Notary_date__c',
      to_sf: ->(value) { value.present? ? Date.parse(value)&.iso8601 : nil },
      from_sf: ->(value) { value }
    },
    requested_services: { 
      sf_field: 'Requested_Services__c',
      to_sf: ->(user, _value) { user.salesforce_requested_services },
      from_sf: ->(value) { value&.split(';') }
    },
    fx_quote_referral_consent: { 
      sf_field: 'FX_Quote_Referral_Consent__c',
      to_sf: ->(value) { value ? 'Yes' : 'No' },
      from_sf: ->(value) { value == 'Yes' }
    }
  }.freeze

  class << self
    # Converts User model data to Salesforce payload format
    # @param user [User] The user model instance
    # @return [Hash] Salesforce-formatted attributes
    def adapt_to(user)
      result = {}
      
      FIELD_MAPPINGS.each do |user_field, config|
        sf_field = config[:sf_field]
        user_value = user.public_send(user_field)
        
        if config[:to_sf]
          # Use custom transformation for to_sf
          if config[:to_sf].arity == 2
            result[sf_field.to_sym] = config[:to_sf].call(user, user_value)
          else
            result[sf_field.to_sym] = config[:to_sf].call(user_value)
          end
        elsif config[:transform]
          # Use legacy transform (for backwards compatibility)
          result[sf_field.to_sym] = config[:transform].call(user, user_value)
        else
          # Direct mapping
          result[sf_field.to_sym] = user_value
        end
      end
      
      result
    end

    # Converts Salesforce contact data to User model attributes
    # @param sf_contact [Object] Salesforce contact object
    # @return [Hash] User model attributes hash
    def adapt_from(sf_contact)
      result = {}
      
      FIELD_MAPPINGS.each do |user_field, config|
        sf_field = config[:sf_field]
        sf_value = sf_contact.public_send(sf_field)
        
        if config[:from_sf]
          # Use custom transformation for from_sf
          result[user_field] = config[:from_sf].call(sf_value)
        else
          # Direct mapping
          result[user_field] = sf_value
        end
      end
      
      result
    end
  end
end
