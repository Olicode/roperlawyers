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
        ContactMailer.send_email(@contact).deliver_now
        format.html { redirect_to root_url, notice: "Message Sent!" }
        format.json { render json: { success: true, message: "Message sent successfully!" } }
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
