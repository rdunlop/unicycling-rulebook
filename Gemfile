source 'https://rubygems.org'

ruby "2.2.3"
gem 'rails', '4.2.5'

# authorization
gem 'devise'
gem "devise-async"
gem 'pundit'

# front end
gem 'haml'
gem 'momentjs-rails'
gem 'tinymce-rails'
gem 'select2-rails'
gem 'formtastic' # currently user for user-confirmation step only
gem 'breadcrumbs_on_rails'
gem 'sass-rails'
gem 'coffee-rails'
gem 'uglifier', '>= 1.0.3'
gem 'foundation-rails'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
#gem 'therubyracer'

# allows storing of secrets in ENV for heroku
gem 'heroku_secrets', github: 'alexpeattie/heroku_secrets'

gem 'apartment'
gem 'exception_notification'
gem 'aws-sdk-rails'
gem 'mailjet'
gem 'newrelic_rpm'

# other
gem 'rake'
gem 'pg'
gem 'unicorn'
gem 'redis-rails'
gem 'redis-namespace'
gem 'sidekiq'
# if you require 'sinatra' you get the Sinatra DSL extended to Object
gem 'sinatra', '>= 1.3.0', require: nil # necessary for sidekiq
gem 'apartment-sidekiq'
gem 'whenever'

# deployment
gem 'capistrano'
gem 'capistrano-rails'
gem 'capistrano-rvm'
gem 'capistrano-bundler'
gem 'capistrano3-unicorn'
gem 'capistrano-sidekiq', github: 'seuros/capistrano-sidekiq'

group :development, :test, :cucumber do
  gem 'html2haml'
  gem 'consistency_fail'
  gem 'web-console', '~> 2.0'
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
  gem 'rubocop', require: false
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
