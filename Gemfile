source 'https://rubygems.org'

ruby "2.1.2"
gem 'rails', '4.1.7'

# authorization
gem 'devise'
gem "devise-async"
gem 'cancancan', '~> 1.9'

# front end
gem 'haml'
gem 'momentjs-rails'
gem 'tinymce-rails'
gem 'chosen-rails'
gem 'formtastic' # currently user for user-confirmation step only
gem 'breadcrumbs_on_rails'
gem 'sass-rails'
gem 'coffee-rails'
gem 'uglifier', '>= 1.0.3'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
#gem 'therubyracer'

# allows storing of secrets in ENV for heroku
gem 'heroku_secrets', github: 'alexpeattie/heroku_secrets'

gem 'apartment'
gem 'exception_notification'
gem 'aws-sdk'
gem 'mailjet'
gem 'newrelic_rpm'

# other
gem 'rake'
gem 'pg'
gem 'unicorn'
gem 'redis-rails'
gem 'sidekiq'
# if you require 'sinatra' you get the Sinatra DSL extended to Object
gem 'sinatra', '>= 1.3.0', :require => nil # necessary for sidekiq
gem 'apartment-sidekiq'
gem 'whenever'

# deployment
gem 'capistrano'
gem 'capistrano-rails'
gem 'capistrano-rvm'
gem 'capistrano-bundler'
gem 'capistrano3-unicorn'
gem 'capistrano-sidekiq' , github: 'seuros/capistrano-sidekiq'

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
