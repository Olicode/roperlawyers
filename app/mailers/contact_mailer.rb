class ContactMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.contact_mailer.send_email.subject
  #
  def send_email(contact)
    @contact = contact

    mail to: "info@roperlawyers.com"
  end

  def send_email_to_client(contact)
    @contact = contact

    mail to: @contact.email
  end
end
