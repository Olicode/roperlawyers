module PagesHelper
  SERVICE_H1_PREFIXES = {
    'buying_property' => 'Conveyancing Lawyer for Buying Property',
    'selling_property' => 'Property Lawyer for Selling Property',
    'wills' => 'Will Writing Lawyer',
    'inheritance' => 'Inheritance Lawyer',
    'new_build_registration' => 'New Build Registration Lawyer',
    'holiday_rental_license' => 'Holiday Rental License Lawyer'
  }.freeze

  def service_page_h1(service_key, location_name)
    prefix = SERVICE_H1_PREFIXES[service_key] || 'Property Lawyer'
    "#{prefix} in #{location_name}"
  end
end
