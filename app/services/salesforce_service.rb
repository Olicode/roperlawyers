# frozen_string_literal: true

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

  def self.create_or_update_contact(attrs)
    new.client.upsert!('Contact', 'Email', attrs)
  end

  def self.upload_file(attrs)
    begin
      Rails.logger.info "Attempting to upload file to Salesforce: #{attrs[:convent_version][:Title]}"
      content_version = new.client.create!('ContentVersion', attrs[:convent_version])
      cv = new.client.query("SELECT Id, ContentDocumentId FROM ContentVersion WHERE Id = '#{content_version}'").first
      new.client.create!(
        'ContentDocumentLink',
        attrs[:content_document_link].merge(ContentDocumentId: cv['ContentDocumentId'])
      )
      Rails.logger.info "Successfully uploaded file to Salesforce"
    rescue => e
      Rails.logger.error "Error in SalesforceService.upload_file: #{e.message}"
      Rails.logger.error e.backtrace.join("\n")
      raise e
    end
  end

  def self.find_contact(sf_contact_id)
    new.client.find('Contact', sf_contact_id)
  end

  def client
    @client ||= Restforce.new(
      # 
      host: ENV['SALESFORCE_HOST'],
      api_version: '51.0',
      username: ENV['SALESFORCE_USER_NAME'],
      password: ENV['SALESFORCE_PASSWORD'],
      client_id: ENV['SALESFORCE_CLIENT_ID'],
      client_secret: ENV['SALESFORCE_CLIENT_SECRET'],
      security_token: ENV['SALESFORCE_SECURITY_TOKEN']
    )
  end


end
