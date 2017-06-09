source 'https://rubygems.org'
ruby '2.2.3'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.6'
gem 'pg'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'jquery-rails'
gem 'bcrypt', '~> 3.1.7'
gem 'bootstrap', '~> 4.0.0.alpha6'
gem 'country_select', '3.0.0'
gem 'language_list'
gem 'browser'
gem 'carrierwave', '~> 1.0'
gem 'fog-aws'
gem 'mini_magick'
gem 'has_secure_token'
gem 'faker'
gem 'resque', "~> 1.27.0"
gem 'puma'
gem 'newrelic_rpm'
gem "rack-timeout"
gem 'aws-sdk', '~> 2'

source 'https://rails-assets.org' do
  gem 'rails-assets-tether', '>= 1.3.3'
end
# Use Unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

group :development, :test do
  gem 'byebug'
  gem 'rspec-rails'
  gem 'capybara'
  gem 'factory_girl_rails', require: false
  gem 'rubocop', require: false
  gem 'shoulda-matchers', '~> 3.1'
  gem 'guard-rspec', require: false
  gem 'dotenv-rails'
end

gem 'codeclimate-test-reporter', group: :test, require: nil
gem 'bullet', group: 'development'

group :development do
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
end

group :production do
  gem 'rails_12factor'
end
