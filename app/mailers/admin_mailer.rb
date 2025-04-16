class AdminMailer < ApplicationMailer
  default from: 'info@roperlawyers.com'

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.admin_mailer.send_user_updates.subject
  #
  def send_user_updates(user)
    @user = user
    @greeting = "Hi"

    mail(
      to: 'info@roperlawyers.com',
      subject: "User form update from #{user.email}"
    )
  end
end
