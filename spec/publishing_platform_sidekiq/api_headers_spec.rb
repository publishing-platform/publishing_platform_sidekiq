require "publishing_platform_sidekiq/api_headers"

RSpec.describe PublishingPlatformSidekiq::APIHeaders do
  describe PublishingPlatformSidekiq::APIHeaders::ClientMiddleware do
    let(:publishing_platform_request_id) { "some-unique-request-id" }
    let(:publishing_platform_authenticated_user) { "some-unique-user-id" }

    let(:preexisting_request_id) { "some-preexisting-request-id" }
    let(:preexisting_authenticated_user) { "some-preexisting-user-id" }

    it "adds the publishing_platform_request_id and publishing_platform_authenticated_user to the job arguments" do
      PublishingPlatformApi::PublishingPlatformHeaders.set_header(:publishing_platform_request_id, publishing_platform_request_id)
      PublishingPlatformApi::PublishingPlatformHeaders.set_header(:x_publishing_platform_authenticated_user, publishing_platform_authenticated_user)

      job = {
        "args" => [],
      }

      described_class.new.call("worker_class", job, "queue", "redis_pool") do
        expect(job["args"].last["request_id"]).to eq(publishing_platform_request_id)
        expect(job["args"].last["authenticated_user"]).to eq(publishing_platform_authenticated_user)
      end
    end

    it "doesn't add the publishing_platform_request_id and publishing_platform_authenticated_user to the job arguments if they are already present" do
      PublishingPlatformApi::PublishingPlatformHeaders.set_header(:publishing_platform_request_id, publishing_platform_request_id)
      PublishingPlatformApi::PublishingPlatformHeaders.set_header(:x_publishing_platform_authenticated_user, publishing_platform_authenticated_user)

      job = {
        "args" => [{ "authenticated_user" => preexisting_authenticated_user, "request_id" => preexisting_request_id }],
      }

      described_class.new.call("worker_class", job, "queue", "redis_pool") do
        expect(job["args"].last["request_id"]).to eq(preexisting_request_id)
        expect(job["args"].last["authenticated_user"]).to eq(preexisting_authenticated_user)
      end
    end

    it "adds the publishing_platform_request_id if it is missing but publishing_platform_authenticated_user is present" do
      PublishingPlatformApi::PublishingPlatformHeaders.set_header(:publishing_platform_request_id, publishing_platform_request_id)

      job = {
        "args" => [{ "authenticated_user" => publishing_platform_authenticated_user }],
      }

      described_class.new.call("worker_class", job, "queue", "redis_pool") do
        expect(job["args"].last["request_id"]).to eq(publishing_platform_request_id)
        expect(job["args"].last["authenticated_user"]).to eq(publishing_platform_authenticated_user)
      end
    end

    it "adds the publishing_platform_authenticated_user if it is missing but publishing_platform_request_id is present" do
      PublishingPlatformApi::PublishingPlatformHeaders.set_header(:x_publishing_platform_authenticated_user, publishing_platform_authenticated_user)

      job = {
        "args" => [{ "request_id" => publishing_platform_request_id }],
      }

      described_class.new.call("worker_class", job, "queue", "redis_pool") do
        expect(job["args"].last["request_id"]).to eq(publishing_platform_request_id)
        expect(job["args"].last["authenticated_user"]).to eq(publishing_platform_authenticated_user)
      end
    end

    it "doesn't affect other values in the metadata hash" do
      PublishingPlatformApi::PublishingPlatformHeaders.set_header(:x_publishing_platform_authenticated_user, publishing_platform_authenticated_user)

      job = {
        "args" => [{ "request_id" => publishing_platform_request_id, "other_request_id" => preexisting_request_id }],
      }

      described_class.new.call("worker_class", job, "queue", "redis_pool") do
        expect(job["args"].last["request_id"]).to eq(publishing_platform_request_id)
        expect(job["args"].last["other_request_id"]).to eq(preexisting_request_id)
        expect(job["args"].last["authenticated_user"]).to eq(publishing_platform_authenticated_user)
      end
    end
  end

  describe PublishingPlatformSidekiq::APIHeaders::ServerMiddleware do
    let(:publishing_platform_request_id) { "some-unique-request-id" }
    let(:publishing_platform_authenticated_user) { "some-unique-user-id" }

    it "removes the publishing_platform_request_id from the job arguments ands adds it to the API headers" do
      message = {
        "args" => [
          "some arg",
          { "authenticated_user" => publishing_platform_authenticated_user, "request_id" => publishing_platform_request_id },
        ],
      }

      described_class.new.call("worker", message, "queue") do
        expect(message["args"]).to eq(["some arg"])
        expect(PublishingPlatformApi::PublishingPlatformHeaders.headers[:publishing_platform_request_id]).to eq(publishing_platform_request_id)
        expect(PublishingPlatformApi::PublishingPlatformHeaders.headers[:x_publishing_platform_authenticated_user]).to eq(publishing_platform_authenticated_user)
        expect(Sidekiq::Context.current).to eq({ "publishing_platform_request_id" => publishing_platform_request_id })
      end
    end

    it "does nothing if the last argument is not a hash" do
      message = {
        "args" => [
          "some arg",
          "some other arg",
        ],
      }

      original_message = message.dup

      expect(PublishingPlatformApi::PublishingPlatformHeaders).not_to receive(:set_header)
      expect(Sidekiq::Context).not_to receive(:add)

      described_class.new.call("worker", message, "queue") do
        expect(message).to eq(original_message)
      end
    end

    it "does nothing if the last argument is a hash with no request_id key" do
      message = {
        "args" => [
          { "some arg" => "some value" },
        ],
      }

      original_message = message.dup

      expect(PublishingPlatformApi::PublishingPlatformHeaders).not_to receive(:set_header)
      expect(Sidekiq::Context).not_to receive(:add)

      described_class.new.call("worker", message, "queue") do
        expect(message).to eq(original_message)
      end
    end
  end
end
