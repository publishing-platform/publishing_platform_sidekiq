require "sidekiq"
require "publishing_platform_sidekiq/api_headers"

module PublishingPlatformSidekiq
  module SidekiqInitializer
    def self.setup_sidekiq(redis_config = {})
      redis_config = redis_config.merge(reconnect_attempts: [15, 30, 45, 60])

      Sidekiq.configure_server do |config|
        config.logger = Sidekiq::Logger.new($stdout)
        config.redis = redis_config

        config.server_middleware do |chain|
          chain.add PublishingPlatformSidekiq::APIHeaders::ServerMiddleware
        end
      end

      Sidekiq.configure_client do |config|
        config.redis = redis_config

        config.client_middleware do |chain|
          chain.add PublishingPlatformSidekiq::APIHeaders::ClientMiddleware
        end
      end
    end
  end
end
