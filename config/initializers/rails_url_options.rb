host = Rails.application.config.action_mailer.default_url_options[:host]
port = Rails.application.config.action_mailer.default_url_options[:port]
protocol = Rails.application.config.action_mailer.default_url_options[:protocol]
Rails.application.config.action_mailer.default_url_options = {
  host: host,
  port: port,
  protocol: protocol,
}

# Share default url options between our mailers and routes helpers
Rails.application.default_url_options = Rails.application.config.action_mailer.default_url_options
