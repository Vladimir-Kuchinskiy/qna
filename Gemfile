# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.3.1'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.2.0'
# Use postgresql as the database for Active Record
gem 'pg', '>= 0.18', '< 2.0'
# Use Puma as the app server
gem 'puma', '~> 3.11'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'mini_racer', platforms: :ruby

# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

gem 'active_model_serializers'
gem 'bootstrap'
gem 'cancancan'
gem 'carrierwave'
gem 'cocoon'
gem 'devise'
gem 'doorkeeper', '4.2.6'
gem 'gon'
gem 'jquery-rails'
gem 'momentjs-rails' # For js moment time with format customization
gem 'mysql2', require: 'thinking_sphinx'
gem 'oj'
gem 'oj_mimic_json'
gem 'omniauth'
gem 'omniauth-facebook'
gem 'omniauth-github'
gem 'rails-controller-testing'
gem 'remotipart'
gem 'responders'
gem 'sidekiq'
gem 'simple_form'
gem 'sinatra', github: 'sinatra/sinatra', require: nil
gem 'skim'
gem 'slim-rails'
gem 'thinking-sphinx', '~> 3.1.4'
gem 'whenever'
gem 'will_paginate-bootstrap4'
gem 'dotenv'
gem 'dotenv-deployment', require: 'dotenv/deployment'
gem 'mini_racer'
gem 'unicorn'
gem 'redis-rails'

# Use ActiveStorage variant
# gem 'mini_magick', '~> 4.8'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.1.0', require: false

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'capistrano', require: false
  gem 'capistrano-bundler', require: false
  gem 'capistrano-rails', require: false
  gem 'capistrano-rvm', require: false
  gem 'capistrano-sidekiq', require: false
  gem 'capistrano3-unicorn', require: false
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'web-console', '>= 3.3.0'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '>= 2.15', '< 4.0'
  gem 'launchy'
  # Easy installation and use of chromedriver to run system tests with Chrome
  gem 'chromedriver-helper'
  gem 'json_spec'
  gem 'shoulda-matchers'
end

group :test, :development do
  gem 'capybara-email'
  gem 'capybara-webkit'
  gem 'database_cleaner'
  gem 'factory_bot_rails'
  gem 'letter_opener'
  gem 'phantomjs', require: 'phantomjs/poltergeist'
  gem 'poltergeist'
  gem 'rspec-rails'
  gem 'rubocop-rspec'
  gem 'webdrivers'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
