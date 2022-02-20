class TransactionalMailer < ActionMailer::Base
  def contact_us(email)
    @email = email
    mail(to: email, subject: 'Thanks for contacting us!')
  end
end
