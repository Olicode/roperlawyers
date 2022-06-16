# Preview all emails at http://localhost:3000/rails/mailers/admin_mailer
class AdminMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/admin_mailer/send_user_updates
  def send_user_updates
    AdminMailer.send_user_updates
  end

end
