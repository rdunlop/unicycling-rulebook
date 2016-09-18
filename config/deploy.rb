# config valid only for Capistrano 3.6
lock '3.6.1'

set :eye_env, -> { {rails_env: fetch(:rails_env)} }
set :application, 'unicycling-rulebook'
set :repo_url, 'git@github.com:rdunlop/unicycling-rulebook.git'
set :stages, %w(prod)

# Default value for :linked_files is []
set :linked_files, %w{config/eye.yml config/database.yml config/secrets.yml config/newrelic.yml}

# Default value for linked_dirs is []
set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system public/sitemaps}

set :whenever_command,      ->{ [:bundle, :exec, :whenever] }
set :whenever_environment,  ->{ fetch :rails_env }
set :whenever_identifier,   ->{ fetch :application }
set :whenever_roles,        ->{ [:db, :app] }
