source 'https://rubygems.org'

git_source(:github) { |repo_name| "https://github.com/#{repo_name}.git" }

ruby File.open(File.expand_path(".ruby-version", File.dirname(__FILE__))) { |f| f.read.chomp }
gem 'rails', "~> 7.1.5"
gem 'sprockets', '< 4' # sprockets 4 causes issues we don't need to solve

# authorization
gem 'devise'
gem 'pundit'

# front end
gem 'breadcrumbs_on_rails'
gem 'coffee-rails'
gem 'formtastic' # currently user for user-confirmation step only
gem 'foundation-rails'
gem 'haml'
gem 'momentjs-rails'
gem 'sass-rails'
gem 'select2-rails'
gem 'tinymce-rails'
gem 'uglifier', '>= 1.0.3'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer'

# allows storing of secrets in ENV for heroku
gem 'heroku_secrets', github: 'alexpeattie/heroku_secrets'

gem 'aws-sdk-rails'
gem 'mailjet'
gem 'pry-rails' # supports the custom apartment console
gem 'recaptcha'
gem 'rollbar'
gem 'ros-apartment', require: 'apartment'

# other
gem 'apartment_acme_client'
gem 'pg'
gem 'rake'
gem 'redis'
gem 'ros-apartment-sidekiq', require: 'apartment-sidekiq'
gem 'sidekiq'
gem 'unicorn'
gem 'whenever'

# deployment
gem 'capistrano'
gem 'capistrano3-unicorn'
gem 'capistrano-bundler'
gem "capistrano-deploytags", require: false
gem 'capistrano-rails'
gem 'capistrano-rvm'
gem 'eye-patch', require: false

group :development, :test, :cucumber do
  gem 'annotate'
  gem 'bundler-audit', require: false
  gem 'capybara'
  gem 'codeclimate_circle_ci_coverage'
  gem 'consistency_fail'
  gem 'factory_bot_rails'
  gem 'html2haml'
  gem 'pry'
  gem 'rspec-rails'
  gem 'rubocop',  '1.68.0', require: false
  gem 'rubocop-rails', require: false
end

group :test do
  gem 'rails-controller-testing'
  gem 'rspec_junit_formatter' # as per circleCI https://circleci.com/docs/test-metadata
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
