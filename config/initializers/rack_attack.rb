# Throttle the endpoints that accept a secret, so the secret can't be guessed by brute force.
# In Nov 2026 a scanner made about 50 rulebook creation attempts and 108 sign-in attempts in a few minutes.
#
# The counters live in memory, per process. That is fine while prod runs one ECS task with a single
# Puma process (WEB_CONCURRENCY unset). With more tasks or workers, move this to a shared store (Redis).
#
# req.ip skips private proxy addresses in X-Forwarded-For, so behind the ALB it is the client's IP.
Rack::Attack.cache.store = ActiveSupport::Cache::MemoryStore.new

post_to = ->(req, path) { req.post? && req.path == path }

Rack::Attack.throttle("rulebooks/create/ip", limit: 5, period: 10.minutes) do |req|
  req.ip if post_to.call(req, "/rulebooks")
end

Rack::Attack.throttle("admin_upgrades/create/ip", limit: 5, period: 10.minutes) do |req|
  req.ip if post_to.call(req, "/admin_upgrades")
end

Rack::Attack.throttle("users/sign_in/ip", limit: 10, period: 1.minute) do |req|
  req.ip if post_to.call(req, "/users/sign_in")
end

Rack::Attack.throttle("users/sign_in/email", limit: 5, period: 1.minute) do |req|
  if post_to.call(req, "/users/sign_in")
    email = req.params.dig("user", "email")
    email.downcase.strip.presence if email.is_a?(String)
  end
end

Rack::Attack.throttle("users/password/ip", limit: 5, period: 1.hour) do |req|
  req.ip if post_to.call(req, "/users/password")
end

ActiveSupport::Notifications.subscribe("throttle.rack_attack") do |_name, _start, _finish, _id, payload|
  req = payload[:request]
  Rails.logger.warn("[rack-attack] throttled #{req.env['rack.attack.matched']} #{req.request_method} #{req.path} ip=#{req.ip}")
end
