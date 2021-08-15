# Use HEROKU_APP_NAME env var to generate root url for url helpers, if present
if ENV['HEROKU_APP_NAME'].present?
  host = "#{ENV["HEROKU_APP_NAME"]}.herokuapp.com"
  port = Rails.application.config.action_mailer.default_url_options[:port]
  protocol = Rails.application.config.action_mailer.default_url_options[:protocol]
  Rails.application.config.action_mailer.default_url_options = {
    host: host,
    port: port,
    protocol: protocol,
  }
end

# Share default url options between our mailers and routes helpers
Rails.application.default_url_options = Rails.application.config.action_mailer.default_url_options
