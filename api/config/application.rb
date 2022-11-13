require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Api
  class Application < Rails::Application
    config.api_only = true

    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
    config.generators.test_framework :rspec

    config.eager_load_paths << Rails.root.join('lib')

    config.x.jwt_secret = 'c8aP9xnmwXTWF1BMeBsHx02AnLe1eLDbZ50V9MQJPw'
    config.x.fetcher_url = 'http://localhost:8070'

    config.active_job.queue_adapter = :sidekiq

    config.action_view.sanitized_allowed_tags = ['p', 'strong', 'em', 'u', 'a', 'span', 'blockquote', 'pre', 'sub', 'sup']
    config.action_view.sanitized_allowed_attributes = ['href', 'rel', 'class', 'style', 'spellcheck', 'target', 'title']
  end
end
