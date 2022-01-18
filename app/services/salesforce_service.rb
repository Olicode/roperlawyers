class SalesforceService
  def self.health
    new.client.query("select Name from User").count > 0
  rescue StandardError => e
    e.message
  end

  def self.create_contact(attrs)
    new.client.create!('Contact', attrs)
  end

  def self.update_contact(attrs)
    new.client.update!('Contact', attrs)
  end

  def client
    @client ||= Restforce.new(
      # host: ENV['SALESFORCE_HOST'],
      api_version: '51.0',
      username: ENV['SALESFORCE_USER_NAME'],
      password: ENV['SALESFORCE_PASSWORD'],
      client_id: ENV['SALESFORCE_CLIENT_ID'],
      client_secret: ENV['SALESFORCE_CLIENT_SECRET'],
      security_token: ENV['SALESFORCE_SECURITY_TOKEN']
    )
  end


end
