# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.3'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.2.3'
# Use sqlite3 as the database for Active Record
gem 'pg'
# Use Puma as the app server
gem 'puma', '~> 3.11'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'mini_racer', platforms: :ruby

# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use ActiveStorage variant
# gem 'mini_magick', '~> 4.8'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.1.0', require: false

# Authentication
gem 'devise', '~> 4.6.2'
gem 'devise_invitable', '~> 2.0.0'

# Authorization
gem 'pundit'

# CSS framework
gem 'bootstrap', '~> 4.3.1'
gem 'bootstrap_form', '>= 4.2.0'
gem 'jquery-rails'

# easy admin dashboard for editing data
gem 'administrate'

gem 'raygun4ruby'

# Create fake data
gem 'factory_bot_rails'
gem 'faker'

# Log access to database records
gem 'audited', '~> 4.7'

# locale based flash notices for controllers
gem 'responders'

# Soft delete support
gem 'discard', '~> 1.0'

# State machines
gem 'state_machines'
gem 'state_machines-activerecord'

group :production do
  gem 'sendgrid-ruby'
end

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'
  gem 'rubocop', '0.71.0'
  gem 'rubocop-rails'

  # Open emails in a browser tab instead of sending
  gem 'letter_opener'

  gem 'percy-capybara', '~> 4.0.0'
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'web-console', '>= 3.3.0'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'

  gem 'i18n-tasks', '~> 0.9.29'
end

group :test do
  gem 'rails-controller-testing'
  gem 'rspec-rails', '~> 3.8'

  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '>= 2.15'
  gem 'capybara-screenshot' # for test debugging
  gem 'capybara-selenium'
  gem 'selenium-webdriver'

  gem 'simplecov', require: false

  gem 'webdrivers'

  gem 'pundit-matchers', '~> 1.6.0'

end
