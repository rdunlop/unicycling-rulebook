RSpec.configure do |config|
  # Throttle counters persist in memory across examples; start each one with a clean slate.
  config.before do
    Rack::Attack.reset!
  end
end
