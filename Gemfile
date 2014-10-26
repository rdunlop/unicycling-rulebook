source 'https://rubygems.org'

ruby "2.1.2"
gem 'rails', '4.1.6'

gem 'rake'
gem 'devise'
gem 'cancancan', '~> 1.9'
gem 'exception_notification'

#gem 'sqlite3'
gem 'pg'
gem 'haml'
gem 'momentjs-rails'
gem 'tinymce-rails'
gem 'chosen-rails'
gem 'formtastic' # currently user for user-confirmation step only
# allows storing of secrets in ENV for heroku
gem 'heroku_secrets', github: 'alexpeattie/heroku_secrets'

gem 'apartment'
gem 'breadcrumbs_on_rails'
gem 'aws-sdk'

group :development, :test, :cucumber do
    gem 'html2haml'
    gem 'consistency_fail'
    gem 'better_errors'
    gem "binding_of_caller"
    gem 'brakeman'
    gem 'annotate'
    gem 'factory_girl_rails'
    gem 'rspec-rails'
    gem 'capybara'
    gem 'spork'
    gem 'syntax'
    gem 'watchr'
    gem 'foreman'
    gem 'pry'
end

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails'
  gem 'coffee-rails'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  # gem 'therubyracer'

  gem 'uglifier', '>= 1.0.3'
end

gem 'jquery-rails'

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the app server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'ruby-debug19', :require => 'ruby-debug'
