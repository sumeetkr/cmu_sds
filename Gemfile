source 'https://rubygems.org'

gem 'rails', '3.2.9'
gem 'devise'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

# Amazon Web Services
gem 'aws-sdk', '1.7.1'

gem 'bootstrap-sass-rails'
gem 'heroku'
gem 'httparty'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'uglifier', '>= 1.0.3'
end

gem 'jquery-rails'

group :development, :test do
  gem 'sqlite3', '1.3.5'

  #Used to annotate models with the database schema
  gem 'annotate'

  #Gems for testing
  gem 'rspec-rails'
  gem 'shoulda-matchers'
  gem 'spork-rails'
  gem 'guard-rspec'
  gem 'guard-spork'

  #Guard dependencies
  gem 'rb-fsevent'
  gem 'growl'
  gem 'rails-erd'
end

group :test do
  #Integration
  gem 'capybara'
  # So that capybara can launch a browser
  gem 'launchy'

  #Code coverage
  gem 'simplecov'

  gem 'database_cleaner'
end

group :production do
  gem 'pg', '0.12.2'
end

