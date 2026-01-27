class ContactsController < ApplicationController
  # Skip CSRF verification for contact_notification endpoint
  skip_before_action :verify_authenticity_token, only: [:contact_notification]
  
  # GET /contacts/new
  def new
    @contact = Contact.new
  end

  # POST /contacts or /contacts.json
  def create
    @contact = Contact.new(contact_params)
    
    respond_to do |format|
      if @contact.save
        begin
          # Only send email if CONTACT_MAILER_ADDRESS is set
          if ENV['CONTACT_MAILER_ADDRESS'].present?
            ContactMailer.send_email(@contact).deliver_now
          else
            Rails.logger.warn "CONTACT_MAILER_ADDRESS not set - email not sent"
          end
          
          format.html { redirect_to root_url, notice: "Message Sent!" }
          format.json { render json: { success: true, message: "Message sent successfully!" } }
        rescue => e
          Rails.logger.error "Failed to send contact email: #{e.message}"
          format.html { redirect_to root_url, alert: "Message saved but email could not be sent." }
          format.json { render json: { success: false, errors: ["Message saved but email could not be sent: #{e.message}"] } }
        end
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: { success: false, errors: @contact.errors.full_messages } }
      end
    end
  end

  def test_email
    begin
      # Test email with sample data
      test_data = {
        first_name: 'Test',
        last_name: 'User',
        email: 'test@example.com',
        mobile_phone: '1234567890',
        message: 'This is a test email from the contact form system.'
      }
      
      Rails.logger.info "Sending test email to: info@roperlawyers.com"
      ContactMailer.propertybase_notification(test_data).deliver_now
      Rails.logger.info "Test email sent successfully"
      
      render json: { success: true, message: 'Test email sent successfully' }
      
    rescue => e
      Rails.logger.error "Test email error: #{e.message}"
      render json: { success: false, message: e.message }, status: :internal_server_error
    end
  end

  def contact_notification
    begin
      # Extract form data
      form_data = {
        first_name: params.dig(:contact, :FirstName),
        last_name: params.dig(:contact, :LastName),
        email: params.dig(:contact, :Email),
        mobile_phone: params.dig(:contact, :MobilePhone),
        message: params.dig(:contact, :Contact_Form_Message)
      }
      
      # Guard: if first and last names are identical (case-insensitive), skip email and Salesforce
      if form_data[:first_name].present? && form_data[:last_name].present? && form_data[:first_name].to_s.strip.casecmp?(form_data[:last_name].to_s.strip)
        Rails.logger.info "Contact submission skipped due to identical first and last names"
        respond_to do |format|
          format.html { redirect_to thank_you_path }
          format.json { render json: { success: true, message: 'Thank you' } }
        end
        return
      end

      # Send email notification
      Rails.logger.info "Attempting to send email notification to: info@roperlawyers.com"
      ContactMailer.propertybase_notification(form_data).deliver_now
      Rails.logger.info "Email notification sent successfully"
      
      # Submit to PropertyBase server-side
      submit_to_propertybase(form_data)
      
      # Create contact in Salesforce
      create_salesforce_contact(form_data)
      
      respond_to do |format|
        format.html { redirect_to thank_you_path }
        format.json { render json: { success: true, message: 'Form submitted and email sent successfully' } }
      end
      
    rescue => e
      Rails.logger.error "Contact notification error: #{e.message}"
      respond_to do |format|
        format.html { redirect_to root_path, alert: 'An error occurred. Please try again.' }
        format.json { render json: { success: false, message: e.message }, status: :internal_server_error }
      end
    end
  end

  private

  def submit_to_propertybase(form_data)
    begin
      # Prepare data for PropertyBase
      propertybase_data = {
        'contact[FirstName]' => form_data[:first_name],
        'contact[LastName]' => form_data[:last_name],
        'contact[Email]' => form_data[:email],
        'contact[MobilePhone]' => form_data[:mobile_phone],
        'contact[Contact_Form_Message]' => form_data[:message],
        'h_5c972f06be11bb485b8901a14ec8d41f359cd881' => ''
      }
      
      # Submit to PropertyBase
      uri = URI('https://front-desk.propertybase.com/forms/5c972f06be11bb485b8901a14ec8d41f359cd881')
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      
      request = Net::HTTP::Post.new(uri)
      request.set_form_data(propertybase_data)
      
      response = http.request(request)
      
      Rails.logger.info "PropertyBase submission response: #{response.code} #{response.message}"
      
    rescue => e
      Rails.logger.error "PropertyBase submission error: #{e.message}"
      # Don't raise error - we still want to send the email even if PropertyBase fails
    end
  end

  def create_salesforce_contact(form_data)
    begin
      # Prepare data for Salesforce
      salesforce_data = {
        FirstName: form_data[:first_name],
        LastName: form_data[:last_name],
        Email: form_data[:email],
        MobilePhone: form_data[:mobile_phone],
        Contact_Form_Message__c: form_data[:message],
        LeadSource: 'Website Contact Form'
      }
      
      Rails.logger.info "Creating contact in Salesforce: #{salesforce_data[:Email]}"
      
      # Use create_or_update_contact to upsert based on email
      sf_contact_id = SalesforceService.create_or_update_contact(salesforce_data)
      
      Rails.logger.info "Salesforce contact created/updated successfully: #{sf_contact_id}"
      
    rescue => e
      Rails.logger.error "Salesforce contact creation error: #{e.message}"
      # Don't raise error - we still want the form submission to succeed even if Salesforce fails
    end
  end

  # Only allow a list of trusted parameters through.
  def contact_params
    params.require(:contact).permit(:email, :message)
  end
end
