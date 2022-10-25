source 'https://rubygems.org'

git_source(:github) { |repo_name| "https://github.com/#{repo_name}.git" }

ruby File.open(File.expand_path(".ruby-version", File.dirname(__FILE__))) { |f| f.read.chomp }
gem 'rails'

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

gem 'apartment'
gem 'aws-sdk-rails'
gem 'mailjet'
gem 'newrelic_rpm'
gem 'rollbar'

# other
gem 'apartment-sidekiq'
gem 'apartment_acme_client'
gem 'pg'
gem 'rake'
gem 'redis-namespace'
gem 'redis-rails'
gem 'sidekiq', "< 6"
gem 'unicorn'
gem 'whenever'

# deployment
gem 'capistrano'
gem 'capistrano-bundler'
gem "capistrano-deploytags", require: false
gem 'capistrano-rails'
gem 'capistrano-rvm'
gem 'capistrano3-unicorn'
gem 'eye-patch', require: false

group :development, :test, :cucumber do
  gem 'annotate'
  gem 'brakeman'
  gem 'bundler-audit', require: false
  gem 'capybara'
  gem 'codeclimate_circle_ci_coverage'
  gem 'consistency_fail'
  gem 'factory_bot_rails'
  gem 'foreman'
  gem 'html2haml'
  gem 'pry'
  gem 'rspec-rails'
  gem 'rubocop', require: false
  gem 'syntax'
  gem 'watchr'
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
