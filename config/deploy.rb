set :eye_env, -> { {rails_env: fetch(:rails_env)} }
set :application, 'unicycling-rulebook'
set :repo_url, 'git@github.com:rdunlop/unicycling-rulebook.git'
set :stages, %w(prod)

# Default value for :linked_files is []
set :linked_files, %w{config/eye.rb config/database.yml config/secrets.yml}

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

# EYE (and via eye, sidekiq and unicorn)
set :eye_config, -> { "config/eye.rb" }
set :eye_bin, -> { :eye }
set :eye_roles, -> { :app }
set :eye_env, -> { {} }

set :chruby_map_bins, fetch(:chruby_map_bins, []).push(fetch(:eye_bin))
set :rvm_map_bins, fetch(:rvm_map_bins, []).push(fetch(:eye_bin))
set :rbenv_map_bins, fetch(:rbenv_map_bins, []).push(fetch(:eye_bin))
set :bundle_bins, fetch(:bundle_bins, []).push(fetch(:eye_bin))

namespace :eye do
  desc "Start eye with the desired configuration file"
  task :load_config do
    on roles(fetch(:eye_roles)) do
      within current_path do
        with fetch(:eye_env) do
          execute fetch(:eye_bin), "quit"
          # With ruby 3.1, on Amazon Linux 2023, the following
          # command is hanging unless we have a PTY.
          SSHKit::Backend::Netssh.config.pty = true
          execute fetch(:eye_bin), "load #{fetch(:eye_config)}"
        end
      end
    end
  end

  desc "Start eye with the desired configuration file"
  task :start, :load_config

  desc "Stop eye and all of its monitored tasks"
  task :stop do
    on roles(fetch(:eye_roles)) do
      within current_path do
        with fetch(:eye_env) do
          execute fetch(:eye_bin), "stop all"
          execute fetch(:eye_bin), "quit"
        end
      end
    end
  end

  desc "Restart all tasks monitored by eye"
  task restart: :load_config do
    on roles(fetch(:eye_roles)) do
      within current_path do
        with fetch(:eye_env) do
          execute fetch(:eye_bin), "restart all"
        end
      end
    end
  end
end

if fetch(:eye_default_hooks, true)
  after "deploy:publishing", "deploy:restart"

  namespace :deploy do
    task :restart do
      invoke "eye:restart"
    end
  end
end
