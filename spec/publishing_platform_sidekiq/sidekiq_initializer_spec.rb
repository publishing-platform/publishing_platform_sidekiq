require "publishing_platform_sidekiq/sidekiq_initializer"

RSpec.describe PublishingPlatformSidekiq::SidekiqInitializer do
  it "doesn't error when called" do
    expect {
      described_class.setup_sidekiq({ url: "redis://redis" })
    }.not_to raise_error
  end
end
