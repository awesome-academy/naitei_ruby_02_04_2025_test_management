source "https://rubygems.org"
git_source(:github){|repo| "https://github.com/#{repo}.git"}

ruby "3.2.2"

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 7.0.5"

# The original asset pipeline for Rails [https://github.com/rails/sprockets-rails]
gem "sprockets-rails"

# Use mysql as the database for Active Record
gem "mysql2", "~> 0.5"

# Use the Puma web server [https://github.com/puma/puma]
gem "puma", "~> 5.0"

# Use JavaScript with ESM import maps [https://github.com/rails/importmap-rails]
gem "importmap-rails"

# Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
gem "turbo-rails"

# Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
gem "stimulus-rails"

# Build JSON APIs with ease [https://github.com/rails/jbuilder]
gem "jbuilder"

# Use Redis adapter to run Action Cable in production
# gem "redis", "~> 4.0"

# Use Kredis to get higher-level data types in Redis [https://github.com/rails/kredis]
# gem "kredis"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html]
# gem "bcrypt", "~> 3.1.7"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i(mingw mswin x64_mingw jruby)

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false

gem "devise"

gem "rails-i18n"

gem "config"

gem "pagy"

# Use Sass to process CSS
gem "sassc-rails"

gem "cocoon"

gem "cancancan", "~> 3.0"

gem "ransack"

gem "roo", "~> 2.10.0"
gem "rubyzip", ">= 1.2.0"

gem "axlsx"
gem "axlsx_rails"

gem "activerecord-import"

gem "concurrent-ruby", "1.3.4"

gem 'rack-cors'

gem 'bcrypt', '~> 3.1.12'

gem 'jwt'
# gem "image_processing", "~> 1.2"
# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html]

group :development, :test do
  gem "debug", platforms: %i(mri mingw x64_mingw)
  gem "simplecov-rcov"
  gem "simplecov"
  gem 'faker'
  gem "dotenv-rails"
  gem "letter_opener_web"
  gem "factory_bot_rails"
  gem "rspec-rails"
  gem "rails-controller-testing"
  gem "rubocop", "~> 1.26", require: false
  gem "rubocop-checkstyle_formatter", require: false
  gem "rubocop-rails", "~> 2.14.0", require: false
end

group :development do
  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem "pry-rails"
  gem "web-console"
  # Add speed badges [https://github.com/MiniProfiler/rack-mini-profiler]
  # gem "rack-mini-profiler"

  # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
  # gem "spring"
end

group :test do
  # Use system testing [https://guides.rubyonrails.org/testing.html]
  gem "capybara"
  gem "selenium-webdriver"
  gem "webdrivers"
end
