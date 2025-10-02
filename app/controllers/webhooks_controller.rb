class WebhooksController < ApplicationController
  # Skip CSRF protection for webhooks
  skip_before_action :verify_authenticity_token, only: [:propertybase]
  
  def propertybase
    begin
      # Extract form data from PropertyBase webhook
      form_data = {
        first_name: params.dig(:contact, :FirstName),
        last_name: params.dig(:contact, :LastName),
        email: params.dig(:contact, :Email),
        mobile_phone: params.dig(:contact, :MobilePhone),
        message: params.dig(:contact, :Contact_Form_Message__c)
      }
      
      # Send email notification
      ContactMailer.propertybase_notification(form_data).deliver_now
      
      Rails.logger.info "PropertyBase webhook received and email sent for: #{form_data[:email]}"
      
      # Return success response
      render json: { status: 'success', message: 'Webhook processed successfully' }, status: :ok
      
    rescue => e
      Rails.logger.error "PropertyBase webhook error: #{e.message}"
      Rails.logger.error e.backtrace.join("\n")
      
      # Return error response
      render json: { status: 'error', message: e.message }, status: :internal_server_error
    end
  end
end
