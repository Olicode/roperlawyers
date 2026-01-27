ActionMailer::Base.default :from => 'Roper Lawyers<info@roperlawyers.com>'

ActionMailer::Base.smtp_settings = {
  domain: 'roperlawyers.com',
  address:        "smtp.postmarkapp.com",
  port:            587,
  authentication: :plain,
  user_name:      ENV['POSTMARK_API_KEY'],
  password:       ENV['POSTMARK_API_KEY']
}