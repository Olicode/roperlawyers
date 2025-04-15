Restforce.configure do |config|
  config.api_version = '57.0'  # or whichever version you're using
  
  # Production environment
  if Rails.env.production?
    config.client_id = ENV['SALESFORCE_CLIENT_ID']
    config.client_secret = ENV['SALESFORCE_CLIENT_SECRET']
    config.host = ENV['SALESFORCE_HOST'] || 'login.salesforce.com'
    config.password = ENV['SALESFORCE_PASSWORD']
    config.security_token = ENV['SALESFORCE_SECURITY_TOKEN']
    config.username = ENV['SALESFORCE_USERNAME']
  else
    # Development/Test environment
    config.client_id = ENV['SALESFORCE_CLIENT_ID'] || 'development_client_id'
    config.client_secret = ENV['SALESFORCE_CLIENT_SECRET'] || 'development_client_secret'
    config.host = ENV['SALESFORCE_HOST'] || 'test.salesforce.com'
    config.password = ENV['SALESFORCE_PASSWORD'] || 'development_password'
    config.security_token = ENV['SALESFORCE_SECURITY_TOKEN'] || 'development_token'
    config.username = ENV['SALESFORCE_USERNAME'] || 'development@example.com'
  end
end 