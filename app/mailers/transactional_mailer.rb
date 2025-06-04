class TransactionalMailer < ActionMailer::Base
  def contact_us(email,from, url, body)
    @email = email
    @from = from 
    @url = url
    @message = body
    mail(to: email, subject: "New Message from #{from}", reply_to: from)
  end
end
