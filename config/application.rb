require_relative 'boot'

require 'rails'
require 'active_model/railtie'
require 'active_job/railtie'
require 'active_record/railtie'
require 'active_storage/engine'
require 'action_controller/railtie'
require 'action_mailer/railtie'
require 'action_mailbox/engine'
require 'action_text/engine'
require 'action_view/railtie'
require 'action_cable/engine'
# require "sprockets/railtie"
require 'rails/test_unit/railtie'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module NcasEquipment
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults(6.1)

    config.time_zone = 'Eastern Time (US & Canada)'

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
    config.generators.assets = false
    config.generators.helper = false
    config.generators.stylesheets = false

    ActiveSupport::Inflector.inflections do |inflect|
      inflect.acronym('API')
    end

    config.after_initialize do
      if Rails.env.production?
        if defined?(Rails::Server) # Run only on server start, not `rails c` etc.
          Rails.application.reload_routes!
          API::Telegram.connect_webhook
        end
      else
        Rails.logger.debug('Skipping Telegram webhook init, not running in production.')
      end
    end
  end
end
