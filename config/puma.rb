threads_count = ENV.fetch("RAILS_MAX_THREADS") { 5 }.to_i
threads threads_count, threads_count

environment ENV.fetch("RAILS_ENV") { "development" }

# In development or when PORT is set (e.g. ECS/Fargate), bind to TCP.
# Otherwise bind to the Unix socket that Nginx proxies to on EC2.
if ENV["RAILS_ENV"] == "development" || ENV["PORT"]
  port ENV.fetch("PORT") { 3000 }
else
  bind "unix:///tmp/unicorn-unicycling-rulebook.socket"
end

workers ENV.fetch("WEB_CONCURRENCY") { 0 }.to_i

preload_app!

pidfile "tmp/pids/puma.pid"
state_path "tmp/pids/puma.state"

# Redirect to files on EC2; let stdout flow to CloudWatch when PORT is set (ECS).
stdout_redirect "log/puma.stdout.log", "log/puma.stderr.log", true unless ENV["PORT"]

before_worker_boot do
  ActiveRecord::Base.establish_connection if defined?(ActiveRecord)
end
