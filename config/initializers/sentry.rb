Raven.configure do |config|
  config.dsn = ENV["SENTRY_CONFIG_URL"]
  config.excluded_exceptions = []
  config.environments = %w[ production ]
end