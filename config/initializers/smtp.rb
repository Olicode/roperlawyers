# Use SendGrid for email delivery
ActionMailer::Base.smtp_settings = {
  domain: 'roperlawyers.com',
  address:        "smtp.sendgrid.net",
  port:            587,
  authentication: :plain,
  user_name:      'apikey',
  password:       ENV['SENDGRID_API_KEY'] || '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'
}

ActionMailer::Base.default :from => 'Roper Lawyers<info@roperlawyers.com>'

# Enable delivery
ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.perform_deliveries = true
ActionMailer::Base.raise_delivery_errors = true
