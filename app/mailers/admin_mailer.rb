class AdminMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.admin_mailer.send_user_updates.subject
  #
  def send_user_updates(user)
    @user = user

    mail to: "info@roperlawyers.com"
  end
end
