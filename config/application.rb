require_relative 'boot'

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "active_storage/engine"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "action_cable/engine"
require 'facebook/messenger'
require "active_support/core_ext/hash/keys"
# require "sprockets/railtie"
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module SweepApi
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2

    console do
      Rails::ConsoleMethods.include(ConsoleMethods)
    end

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    # Only loads a smaller set of middleware suitable for API only apps.
    # Middleware like session, flash, cookies can be added back manually.
    # Skip views, helpers and assets when generating a new resource.
    config.api_only = true
    config.time_zone = 'Eastern Time (US & Canada)'
    config.active_job.queue_adapter = :sidekiq
    config.enable_dependency_loading = true
    config.autoload_paths << Rails.root.join('jobs')
    config.autoload_paths << Rails.root.join('lib')
    config.autoload_paths << Rails.root.join('lib/services/')
    config.autoload_paths << Rails.root.join('lib/services/*.rb')
    config.autoload_paths << Rails.root.join('lib/organizers/')
    config.autoload_paths << Rails.root.join('lib/organizers/*.rb')
    config.autoload_paths << Rails.root.join('app/mailers/')
    config.eager_load_paths << Rails.root.join('jobs')
    config.eager_load_paths << Rails.root.join('lib')
    config.eager_load_paths << Rails.root.join('lib/services/')
    config.eager_load_paths << Rails.root.join('lib/services/*.rb')
    config.eager_load_paths << Rails.root.join('app/mailers/')


    config.middleware.use ::Rack::MethodOverride
    config.middleware.insert_before 0, Rack::Cors, debug: true, logger: (-> { Rails.logger }) do
      allow do
        origins '*'

        resource '*',
         expose: ["jwt"],
         headers: :any,
         credentials: false,
         methods: %i(get post put patch delete options head)
      end
    end
  end
end
