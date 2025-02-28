require "sidekiq/testing"
require "publishing_platform_sidekiq/api_headers"

Sidekiq::Testing.server_middleware do |chain|
  chain.add PublishingPlatformSidekiq::APIHeaders::ServerMiddleware
end
