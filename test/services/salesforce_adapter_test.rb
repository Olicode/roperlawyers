# frozen_string_literal: true

require 'test_helper'

class SalesforceAdapterTest < ActiveSupport::TestCase
  def setup
    @user = users(:one) # Assuming you have fixtures
    @sf_contact = OpenStruct.new(
      FirstName: 'John',
      LastName: 'Doe',
      Email: 'john.doe@example.com',
      MobilePhone: '+34123456789',
      Full_name_on_passport__c: 'John Michael Doe',
      Passport_Number__c: 'AB123456',
      Date_of_Birth__c: '1985-06-15',
      Expiry_Date__c: '2030-06-15',
      Nationality__c: 'British',
      Profesi_n__c: 'Engineer',
      Estado_Civil__c: 'Married',
      Spouse__c: 'Jane Doe',
      Home_Address_del__c: '123 Main St, London',
      Buying_Property_Address__c: '456 Beach Ave, Lanzarote',
      Selling_Property_Address__c: '789 Old St, Manchester',
      Father_s_First_Name__c: 'Michael',
      Mother_s_First_Name__c: 'Sarah',
      R_Origin_Bank_Details__c: 'HSBC UK',
      OTB_Origin_Bank_Details__c: 'Santander',
      Balance_Bank_Details__c: 'Barclays',
      Standing_Orders_Bank_Details__c: 'NatWest',
      Needs_PoA__c: true,
      Here_Till__c: '2024-12-31',
      Date_of_decease__c: nil,
      Father_s_Full_Name__c: 'Michael John Doe',
      Father_s_Vital_Status__c: 'Alive',
      Mother_s_Full_Name__c: 'Sarah Jane Smith',
      Mother_s_Vital_Status__c: 'Alive',
      Children__c: '2',
      Outline_of_bequests_and_order_of_success__c: 'To spouse and children',
      Inheritance_to_be_governed_by__c: 'UK Law',
      Energy_Efficiency_Certificate_CEE__c: 'A',
      Escritura__c: 'Yes',
      Wants_to_holiday_let__c: true,
      NIE_Number__c: 'Y1234567L',
      Name_of_the_present_spouse__c: 'Jane Doe',
      Name_of_the_previous_spouses__c: nil,
      Date_of_divorce__c: nil,
      Tax_Resident__c: 'Yes',
      PoA_made_in_Spain__c: 'Yes',
      PoA_for__c: 'Property purchase',
      Currency__c: 'EUR',
      Needs_NIE__c: 'Yes',
      Needs_Mortgage__c: true,
      Has_a_Spanish_Bank_Account__c: 'Yes',
      B_Preferred_Notary_date__c: '2024-08-15',
      Requested_Services__c: 'NIE;Property Purchase;Will',
      FX_Quote_Referral_Consent__c: 'Yes'
    )
  end

  test "adapt_to converts user data to salesforce format" do
    # Mock user methods that might not exist in fixtures
    @user.define_singleton_method(:salesforce_poa_for) { 'Property purchase' }
    @user.define_singleton_method(:salesforce_requested_services) { 'NIE;Property Purchase;Will' }
    @user.define_singleton_method(:fx_quote_referral_consent?) { true }
    
    # Set up user attributes
    @user.first_name = 'John'
    @user.last_name = 'Doe'
    @user.email = 'john.doe@example.com'
    @user.mobile_phone = '+34123456789'
    @user.full_name_on_passport = 'John Michael Doe'
    @user.passport_number = 'AB123456'
    @user.date_of_birth = Date.parse('1985-06-15')
    @user.expiry_date = Date.parse('2030-06-15')
    @user.nationality = 'British'
    @user.profession = 'Engineer'
    @user.marital_status = 'Married'
    @user.spouse = 'Jane Doe'
    @user.home_address = '123 Main St, London'
    @user.buying_property_address = '456 Beach Ave, Lanzarote'
    @user.selling_property_address = '789 Old St, Manchester'
    @user.father_s_first_name = 'Michael'
    @user.mother_s_first_name = 'Sarah'
    @user.r_origin_bank_details = 'HSBC UK'
    @user.otb_origin_bank_details = 'Santander'
    @user.balance_bank_details = 'Barclays'
    @user.standing_orders_bank_details = 'NatWest'
    @user.needs_poa = true
    @user.here_till = '2024-12-31'
    @user.date_of_decease = nil
    @user.father_s_full_name = 'Michael John Doe'
    @user.father_s_vital_status = 'Alive'
    @user.mother_s_full_name = 'Sarah Jane Smith'
    @user.mother_s_vital_status = 'Alive'
    @user.children = '2'
    @user.outline_of_bequests_and_oder_of_success = 'To spouse and children'
    @user.inheritance_to_be_governed_by = 'UK Law'
    @user.energy_efficiency_certificate_cee = 'A'
    @user.escritura = 'Yes'
    @user.wants_to_holiday_let = true
    @user.nie_number = 'Y1234567L'
    @user.name_of_the_present_spouse = 'Jane Doe'
    @user.name_of_the_previous_spouses = nil
    @user.date_of_divorce = nil
    @user.tax_resident = true
    @user.poa_made_in_spain = 'yes'
    @user.currency = 'EUR'
    @user.needs_nie = 'yes'
    @user.needs_mortgage = true
    @user.has_a_spanish_bank_account = 'yes'
    @user.b_preferred_notary_date = Date.parse('2024-08-15')

    result = SalesforceAdapter.adapt_to(@user)

    # Test basic field mappings
    assert_equal 'John', result[:FirstName]
    assert_equal 'Doe', result[:LastName]
    assert_equal 'john.doe@example.com', result[:Email]
    assert_equal '+34123456789', result[:MobilePhone]
    assert_equal 'John Michael Doe', result[:Full_name_on_passport__c]
    assert_equal 'AB123456', result[:Passport_Number__c]
    
    # Test date transformations
    assert_equal '1985-06-15T00:00:00Z', result[:Date_of_Birth__c]
    assert_equal '2030-06-15T00:00:00Z', result[:Expiry_Date__c]
    assert_equal '2024-08-15T00:00:00Z', result[:B_Preferred_Notary_date__c]
    
    # Test boolean transformations
    assert_equal 'Yes', result[:Tax_Resident__c]
    assert_equal 'Yes', result[:PoA_made_in_Spain__c]
    assert_equal 'Yes', result[:Needs_NIE__c]
    assert_equal 'Yes', result[:Has_a_Spanish_Bank_Account__c]
    assert_equal 'Yes', result[:FX_Quote_Referral_Consent__c]
    
    # Test special method calls
    assert_equal 'Property purchase', result[:PoA_for__c]
    assert_equal 'NIE;Property Purchase;Will', result[:Requested_Services__c]
    
    # Test bank details fields
    assert_equal 'HSBC UK', result[:R_Origin_Bank_Details__c]
    assert_equal 'Santander', result[:OTB_Origin_Bank_Details__c]
    assert_equal 'Barclays', result[:Balance_Bank_Details__c]
    assert_equal 'NatWest', result[:Standing_Orders_Bank_Details__c]
  end

  test "adapt_to handles nil last_name by using email" do
    @user.first_name = 'John'
    @user.last_name = nil
    @user.email = 'john.doe@example.com'
    
    result = SalesforceAdapter.adapt_to(@user)
    
    assert_equal 'john.doe@example.com', result[:LastName]
  end

  test "adapt_to handles false boolean values correctly" do
    @user.tax_resident = false
    @user.define_singleton_method(:fx_quote_referral_consent?) { false }
    @user.poa_made_in_spain = 'no'
    @user.needs_nie = 'no'
    @user.has_a_spanish_bank_account = 'no'
    
    result = SalesforceAdapter.adapt_to(@user)
    
    assert_equal 'No', result[:Tax_Resident__c]
    assert_equal 'No', result[:FX_Quote_Referral_Consent__c]
    assert_equal 'No', result[:PoA_made_in_Spain__c]
    assert_equal 'No', result[:Needs_NIE__c]
    assert_equal 'No', result[:Has_a_Spanish_Bank_Account__c]
  end

  test "adapt_from converts salesforce data to user attributes" do
    result = SalesforceAdapter.adapt_from(@sf_contact)

    # Test basic field mappings
    assert_equal 'John', result[:first_name]
    assert_equal 'Doe', result[:last_name]
    assert_equal 'john.doe@example.com', result[:email]
    assert_equal '+34123456789', result[:mobile_phone]
    assert_equal 'John Michael Doe', result[:full_name_on_passport]
    assert_equal 'AB123456', result[:passport_number]
    
    # Test date fields (should pass through as-is)
    assert_equal '1985-06-15', result[:date_of_birth]
    assert_equal '2030-06-15', result[:expiry_date]
    assert_equal '2024-08-15', result[:b_preferred_notary_date]
    
    # Test boolean transformations
    assert_equal true, result[:tax_resident]
    assert_equal true, result[:fx_quote_referral_consent]
    
    # Test array splitting for requested_services
    assert_equal ['NIE', 'Property Purchase', 'Will'], result[:requested_services]
    
    # Test direct mappings that don't transform
    assert_equal 'Yes', result[:poa_made_in_spain]
    assert_equal 'Yes', result[:needs_nie]
    assert_equal 'Yes', result[:has_a_spanish_bank_account]
    assert_equal 'Property purchase', result[:poa_for]
    
    # Test bank details fields
    assert_equal 'HSBC UK', result[:r_origin_bank_details]
    assert_equal 'Santander', result[:otb_origin_bank_details]
    assert_equal 'Barclays', result[:balance_bank_details]
    assert_equal 'NatWest', result[:standing_orders_bank_details]
  end

  test "adapt_from handles boolean edge cases for tax_resident" do
    # Test 'Yes' string
    @sf_contact.Tax_Resident__c = 'Yes'
    result = SalesforceAdapter.adapt_from(@sf_contact)
    assert_equal true, result[:tax_resident]
    
    # Test true boolean
    @sf_contact.Tax_Resident__c = true
    result = SalesforceAdapter.adapt_from(@sf_contact)
    assert_equal true, result[:tax_resident]
    
    # Test 'No' string
    @sf_contact.Tax_Resident__c = 'No'
    result = SalesforceAdapter.adapt_from(@sf_contact)
    assert_equal false, result[:tax_resident]
    
    # Test nil/false
    @sf_contact.Tax_Resident__c = nil
    result = SalesforceAdapter.adapt_from(@sf_contact)
    assert_equal false, result[:tax_resident]
    
    @sf_contact.Tax_Resident__c = false
    result = SalesforceAdapter.adapt_from(@sf_contact)
    assert_equal false, result[:tax_resident]
  end

  test "adapt_from handles nil requested_services" do
    @sf_contact.Requested_Services__c = nil
    result = SalesforceAdapter.adapt_from(@sf_contact)
    
    assert_nil result[:requested_services]
  end

  test "adapt_from handles empty requested_services" do
    @sf_contact.Requested_Services__c = ''
    result = SalesforceAdapter.adapt_from(@sf_contact)
    
    assert_equal [], result[:requested_services]
  end

  test "adapt_to handles nil dates" do
    @user.date_of_birth = nil
    @user.expiry_date = nil
    @user.date_of_decease = nil
    @user.date_of_divorce = nil
    @user.b_preferred_notary_date = nil
    
    result = SalesforceAdapter.adapt_to(@user)
    
    assert_nil result[:Date_of_Birth__c]
    assert_nil result[:Expiry_Date__c]
    assert_nil result[:Date_of_decease__c]
    assert_nil result[:Date_of_divorce__c]
    assert_nil result[:B_Preferred_Notary_date__c]
  end

  test "field mappings constant is frozen" do
    assert SalesforceAdapter::FIELD_MAPPINGS.frozen?
  end

  test "all expected fields are present in mapping" do
    expected_fields = [
      :first_name, :last_name, :email, :mobile_phone, :full_name_on_passport,
      :passport_number, :date_of_birth, :place_of_birth, :expiry_date, :nationality, :profession,
      :marital_status, :spouse, :home_address, :buying_property_address,
      :selling_property_address, :father_s_first_name, :mother_s_first_name,
      :r_origin_bank_details, :otb_origin_bank_details, :balance_bank_details,
      :standing_orders_bank_details, :needs_poa, :here_till, :date_of_decease,
      :father_s_full_name, :father_s_vital_status, :mother_s_full_name,
      :mother_s_vital_status, :children, :outline_of_bequests_and_oder_of_success,
      :inheritance_to_be_governed_by, :energy_efficiency_certificate_cee,
      :escritura, :wants_to_holiday_let, :nie_number, :name_of_the_present_spouse,
      :name_of_the_previous_spouses, :date_of_divorce, :tax_resident,
      :poa_made_in_spain, :poa_for, :currency, :needs_nie, :needs_mortgage,
      :has_a_spanish_bank_account, :b_preferred_notary_date, :requested_services,
      :fx_quote_referral_consent
    ]
    
    expected_fields.each do |field|
      assert SalesforceAdapter::FIELD_MAPPINGS.key?(field), "Missing field: #{field}"
    end
  end
end
