Sentry.init do |config|
  config.dsn = 'https://f503b508eb0a400aa81c1dd16edc100f@o4504493458522112.ingest.sentry.io/4504493458522112'
  config.breadcrumbs_logger = [:active_support_logger, :http_logger]

  # Set traces_sample_rate to 1.0 to capture 100%
  # of transactions for performance monitoring.
  # We recommend adjusting this value in production.
  config.traces_sample_rate = 1.0
  # or
  config.traces_sampler = lambda do |context|
    true
  end
end
