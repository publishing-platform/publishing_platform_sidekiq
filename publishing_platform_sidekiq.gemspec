# frozen_string_literal: true

require_relative "lib/publishing_platform_sidekiq/version"

Gem::Specification.new do |spec|
  spec.name = "publishing_platform_sidekiq"
  spec.version = PublishingPlatformSidekiq::VERSION
  spec.authors = ["Publishing Platform"]

  spec.summary = "Provides standard setup and behaviour for Sidekiq in Publishing Platform applications."
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.2"

  spec.files = Dir.glob("lib/**/*") + %w[README.md LICENSE]
  spec.require_paths = %w[lib]

  spec.add_dependency "publishing_platform_api_adapters", "~> 0.10"
  spec.add_dependency "redis-client", ">= 0.22.2"
  spec.add_dependency "sidekiq", "~> 7.0", "< 8"

  spec.add_development_dependency "climate_control", "~> 1.2"
  spec.add_development_dependency "publishing_platform_rubocop", "~> 0.2"
  spec.add_development_dependency "railties", "~> 8"
  spec.add_development_dependency "simplecov", "~> 0.22"
end
