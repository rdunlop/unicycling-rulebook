threads_count = ENV.fetch("RAILS_MAX_THREADS") { 5 }.to_i
threads threads_count, threads_count

environment ENV.fetch("RAILS_ENV") { "development" }

# Bind to the same UNIX socket that Nginx is already configured to proxy to.
# Keeping this path avoids any Nginx reconfiguration.
if ENV["RAILS_ENV"] == "development"
  port ENV.fetch("PORT") { 3000 }
else
  bind "unix:///tmp/unicorn-unicycling-rulebook.socket"
end

workers ENV.fetch("WEB_CONCURRENCY") { 1 }

preload_app!

pidfile "tmp/pids/puma.pid"
state_path "tmp/pids/puma.state"

stdout_redirect "log/puma.stdout.log", "log/puma.stderr.log", true

before_worker_boot do
  ActiveRecord::Base.establish_connection if defined?(ActiveRecord)
end
