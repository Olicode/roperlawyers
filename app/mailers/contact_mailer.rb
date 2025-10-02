class ContactMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.contact_mailer.send_email.subject
  #
  def send_email(contact)
    @contact = contact

    mail to: ENV['CONTACT_MAILER_ADDRESS']
  end

  def send_email_to_client(contact)
    @contact = contact

    mail to: @contact.email
  end

  def propertybase_notification(form_data)
    @form_data = form_data

    mail to: 'info@roperlawyers.com', subject: 'New Contact Form Submission - PropertyBase'
  end
end
