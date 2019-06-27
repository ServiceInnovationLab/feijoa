# frozen_string_literal: true

require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Feijoa
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2

    config.generators do |g|
      g.orm :active_record
      g.test_framework :rspec, fixture: false
      g.javascript_engine :js
      g.factory_bot true
    end
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    # This setting toggles whether site users can log in with different account
    # types at the same time, for example as an admin_user and a normal user,
    # and access any pages allowed by their active accounts.
    config.allow_multiple_logins = true
  end
end
