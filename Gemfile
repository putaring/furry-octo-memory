source 'https://rubygems.org'
ruby '2.2.3'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.6'
gem 'pg'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'jquery-rails'
gem 'bcrypt', '~> 3.1.7'
gem 'bootstrap', '~> 4.0.0'
gem 'country_select', '3.0.0'
gem 'language_list'
gem 'browser'
gem 'shrine'
gem 'image_processing'
gem 'mini_magick'
gem 'has_secure_token'
gem 'faker'
gem 'shoryuken'
gem 'puma'
gem 'newrelic_rpm'
gem "rack-timeout"
gem 'aws-sdk-sqs'
gem "aws-sdk-s3", "~> 1.2"
gem "aws-sdk-ses"
gem 'kaminari'
gem 'fastimage'

group :development, :test do
  gem 'byebug'
  gem 'rspec-rails'
  gem 'capybara'
  gem 'factory_girl_rails', require: false
  gem 'rubocop', require: false
  gem 'shoulda-matchers', '~> 3.1'
  gem 'dotenv-rails'
  gem 'shrine-memory'
  gem 'selenium-webdriver'
end

gem 'google-api-client', '0.13.0'
gem 'codeclimate-test-reporter', group: :test, require: nil
gem 'bullet', group: 'development'

group :development do
  gem 'brakeman', require: false
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'pry'
end

group :production do
  gem 'rails_12factor'
end
