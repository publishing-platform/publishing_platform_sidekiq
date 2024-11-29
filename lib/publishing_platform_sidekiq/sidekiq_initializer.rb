require "sidekiq"

module PublishingPlatformSidekiq
  module SidekiqInitializer
    def self.setup_sidekiq(redis_config = {})
      redis_config = redis_config.merge(reconnect_attempts: [15, 30, 45, 60])

      Sidekiq.configure_server do |config|
        config.logger = Sidekiq::Logger.new($stdout)
        config.redis = redis_config
      end

      Sidekiq.configure_client do |config|
        config.redis = redis_config
      end
    end
  end
end
