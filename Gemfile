source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.3.4'
gem 'rails', '~> 7.0.5'

gem 'cocoon', '~> 1.1'
gem 'devise', '~> 4.8'
gem "aws-sdk-s3", require: false
gem 'base64'
gem 'bigdecimal'
gem 'importmap-rails', '~> 1.0'
gem 'jbuilder', '~> 2.11'
gem 'mailsafe', '~> 0.3'
gem 'mutex_m'
gem 'net-http', '~> 0.3'
gem 'pg', '~> 1.1'
gem 'puma', '>= 5.6.4'
gem 'recaptcha'
gem 'redis', '~> 4.0'
gem 'rolify', '~> 6.0'
gem 'ruby-lsp'
gem 'sass-rails'
gem 'select2-rails', '~> 4.0'
# gem 'sentry-rails', '~> 5.4'
# gem 'sentry-ruby', '~> 5.4'
gem 'sprockets-rails', '~> 3.4'
gem 'stimulus-rails', '~> 1.0'
gem 'stripe'
gem 'tailwindcss-rails', '~> 2.0'
gem 'turbo-rails', '~> 1.0'

gem 'awesome_print', '~> 1.9'

# Use Kredis to get higher-level data types in Redis [https://github.com/rails/kredis]
# gem "kredis"
# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "bcrypt", "~> 3.1.7"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', require: false
# Use Sass to process CSS
# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
# gem "image_processing", "~> 1.2"

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem

  gem 'pry-byebug', '~> 3.10'
  gem 'pry-rails', '~> 0.3'
end

group :development do
  gem 'annotate', '~> 3.1'
  gem 'better_errors', '~> 2.8'
  gem 'binding_of_caller', '~> 1.0'
  gem 'letter_opener', '~> 1.7'
  gem 'rack-mini-profiler', '~> 3.0.0'
  gem 'rubocop', '~> 1.29.1', require: false
  gem 'rubocop-performance', '~> 1.9', require: false
  gem 'rubocop-rails', '~> 2.9', require: false
  gem 'web-console', '>= 4.1.0'
end

group :test do
  gem 'capybara', '~> 3.38'
  gem 'selenium-webdriver', '~> 4.6'
  gem 'webdrivers', '~> 5.2'
end
