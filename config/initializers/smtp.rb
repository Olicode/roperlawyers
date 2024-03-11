ActionMailer::Base.smtp_settings = {
  domain: 'roperlawyers.com',
  address:        "smtp.sendgrid.net",
  port:            587,
  authentication: :plain,
  user_name:      'apikey',
  password:       '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'
}

ActionMailer::Base.default :from => ENV['MAILER_FROM'] || 'Roper Lawyers<info@roperlawyers.com>'

ActionMailer::Base.smtp_settings = {
  domain: 'roperlawyers.com',
  address:        "smtp.postmarkapp.com",
  port:            587,
  authentication: :plain,
  user_name:      'API_KEY',
  password:       'API_KEY'
}
