# Preview all emails at http://localhost:3000/rails/mailers/admin_mailer
class AdminMailerPreview < ActionMailer::Preview
  # Preview this email at http://localhost:3000/rails/mailers/admin_mailer/send_user_updates
  def send_user_updates
    # Create a sample user with realistic data for preview
    user = User.new(
      email: "john.doe@example.com",
      first_name: "John",
      last_name: "Doe",
      mobile_phone: "+34 123 456 789",
      home_address: "123 Main Street, Madrid, 28001, Madrid, Spain",
      profession: "Software Engineer",
      marital_status: "Married",
      spouse: "Jane Doe",
      tax_resident: true,
      full_name_on_passport: "John Michael Doe",
      passport_number: "AB123456",
      nationality: "British",
      date_of_birth: Date.new(1985, 6, 15),
      expiry_date: Date.new(2030, 6, 15),
      nie_number: "Y1234567Z",
      father_s_first_name: "Michael",
      mother_s_first_name: "Sarah",
      buying_property_address: "456 Beach Avenue, Valencia, 46001, Valencia, Spain",
      selling_property_address: "789 Mountain View, Barcelona, 08001, Barcelona, Spain",
      currency: "EUR",
      fx_quote_referral_consent: true,
      needs_mortgage: "Yes",
      wants_to_holiday_let: "Yes",
      r_origin_bank_details: "HSBC UK, IBAN GB29 MIDL 4012 3456 7890 12",
      otb_origin_bank_details: "HSBC UK, IBAN GB29 MIDL 4012 3456 7890 12",
      balance_bank_details: "HSBC UK, IBAN GB29 MIDL 4012 3456 7890 12",
      standing_orders_bank_details: "Banco Santander, IBAN ES12 3456 7890 1234 5678 9012",
      needs_poa: "yes",
      poa_for: "buying",
      poa_made_in_spain: "yes",
      needs_nie: "no",
      name_of_the_present_spouse: "Jane Doe",
      father_s_vital_status: "Yes",
      mother_s_vital_status: "Yes",
      children: "Emma Doe | 15/03/2010, James Doe | 22/08/2012",
      outline_of_bequests_and_oder_of_success: "All assets in Spain: Jane Doe – 60%, Emma Doe – 20%, James Doe – 20%",
      inheritance_to_be_governed_by: "Law of country of current nationality",
      requested_services: ["Classified Activities", "Purchase", "Sale"]
    )
    
    AdminMailer.send_user_updates(user)
  end
end
