# frozen_string_literal: true

require_relative "lib/publishing_platform_sidekiq/version"

Gem::Specification.new do |spec|
  spec.name = "publishing_platform_sidekiq"
  spec.version = PublishingPlatformSidekiq::VERSION
  spec.authors = ["Publishing Platform"]

  spec.summary = "Provides standard setup and behaviour for Sidekiq in Publishing Platform applications."
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.0"

  spec.files = Dir.glob("lib/**/*") + %w[README.md LICENSE]
  spec.require_paths = %w[lib]

  spec.add_dependency "redis", "< 6"
  spec.add_dependency "redis-namespace", "~> 1.6"
  spec.add_dependency "sidekiq", "~> 6.5", ">= 6.5.12"

  spec.add_development_dependency "publishing_platform_rubocop"
end
