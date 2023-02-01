set :eye_env, -> { {rails_env: fetch(:rails_env)} }
set :application, 'unicycling-rulebook'
set :repo_url, 'git@github.com:rdunlop/unicycling-rulebook.git'
set :stages, %w(prod)

# Default value for :linked_files is []
set :linked_files, %w{config/eye.yml config/database.yml config/secrets.yml}

# Default value for linked_dirs is []
set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system public/sitemaps}

set :whenever_command,      -> { %i[bundle exec whenever] }
set :whenever_environment,  -> { fetch :rails_env }
set :whenever_identifier,   -> { fetch :application }
set :whenever_roles,        -> { %i[db app] }

set :rollbar_token, ENV["ROLLBAR_ACCESS_TOKEN"]
set :rollbar_env, proc { fetch :rails_env }
set :rollbar_role, proc { :app }

set :bundle_jobs, 1 # due to memory limitations on the staging and prod servers
