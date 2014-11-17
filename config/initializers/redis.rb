class Redis
  def self.cache_configuration
    configuration do |config|
      # Can be far out because it's main purpose is to mark it as evictable
      # by Redis's volatile-lru setting.
      # http://redis.io/topics/lru-cache
      config[:expires_in] = 1.year
      config[:namespace] = 'CACHE'
    end
  end

  def self.sidekiq_configuration
    configuration do |config|
      config[:namespace] = 'SIDEKIQ'
    end
  end

  def self.configuration
    valid_options = %w(host port password db)
    config = ::Rails.application.secrets.redis.slice(*valid_options)

    yield config

    config.symbolize_keys
  end
end
