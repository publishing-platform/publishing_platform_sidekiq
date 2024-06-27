require "publishing_platform_sidekiq/sidekiq_initializer"

module PublishingPlatformSidekiq
  class Railtie < Rails::Railtie
    initializer "publishing_platform_sidekiq.initialize_sidekiq" do |app|
      SidekiqInitializer.setup_sidekiq(
        ENV.fetch("PUBLISHING_PLATFORM_APP_NAME", app.root.basename.to_s),
        { url: ENV.fetch("REDIS_URL", "redis://127.0.0.1:6379") },
      )
    end
  end
end
