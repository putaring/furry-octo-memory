source 'https://rubygems.org'
ruby '2.2.3'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.6'

gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'jquery-rails'
gem 'bcrypt', '~> 3.1.7'
gem 'bootstrap', '~> 4.0.0.alpha3'
gem 'country_select'
gem 'language_list'
gem 'browser'
source 'https://rails-assets.org' do
  gem 'rails-assets-tether', '>= 1.1.0'
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
  gem 'faker'
  gem 'guard-rspec', require: false
end

gem 'codeclimate-test-reporter', group: :test, require: nil

group :development do
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'sqlite3'
end

group :production do
  gem 'pg'
  gem 'rails_12factor'
end
