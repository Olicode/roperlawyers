class ContactsController < ApplicationController
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

  private
    # Only allow a list of trusted parameters through.
    def contact_params
      params.require(:contact).permit(:email, :message)
    end
end
