Raven.configure do |config|
  # Don't display the initiation message
  config.silence_ready = true

  # Note that this should only be set if you absolutely don't care about the
  # security of your environment. This makes error logging vulnerable to
  # man-in-the-middle attacks.
  config.ssl_verification = Settings.sentry.ssl_verification

  # Only log staging and production environments, not development / test
  config.environments = %w[ staging production ]

  # Add the filtered logging parameters list to the sanitise the fields
  config.sanitize_fields = Rails.application.config.filter_parameters.map(&:to_s)
end
