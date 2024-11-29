require "publishing_platform_sidekiq/sidekiq_initializer"

module PublishingPlatformSidekiq
  class Railtie < Rails::Railtie
    initializer "publishing_platform_sidekiq.initialize_sidekiq" do
      redis_options = { url: ENV.fetch("REDIS_URL", "redis://127.0.0.1:6379") }

      if ENV["REDIS_SSL_VERIFY_NONE"] == "true"
        redis_options[:ssl_params] = { verify_mode: OpenSSL::SSL::VERIFY_NONE }
      end

      SidekiqInitializer.setup_sidekiq(redis_options)
    end
  end
end
