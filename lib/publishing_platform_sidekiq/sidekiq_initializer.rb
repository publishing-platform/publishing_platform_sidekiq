require "sidekiq"

module PublishingPlatformSidekiq
  module SidekiqInitializer
    def self.setup_sidekiq(publishing_platform_app_name, redis_config = {})
      redis_config = redis_config.merge(
        namespace: publishing_platform_app_name,
        reconnect_attempts: 4,
        reconnect_delay: 15,
        reconnect_delay_max: 60,
      )

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
