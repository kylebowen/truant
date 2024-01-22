# frozen_string_literal: true

require_relative "lib/truant/version"

Gem::Specification.new do |spec|
  spec.name = "truant"
  spec.version = Truant::VERSION
  spec.authors = ["Kyle Bowen"]
  spec.email = ["kyle.m.bowen@gmail.com"]

  spec.summary = "Tool to aid in evaluating the effectiveness of an EDR agent."
  spec.description = <<~DESC
    Endpoint Detection and Response (EDR) agents gather and analyze telemetry
    data to aid in identifying and responding to security incidents and
    potential cyber threats. Such data can include:
    \t- Process creation
    \t- File creation
    \t- File creation, modification, and deletion
    \t- Network connections and data transmission

    This tool allows users to perform activities that will generate data and log
    it locally for comparison with the data gathered by your chosen EDR.
  DESC
  spec.homepage = "https://github.com/kylebowen/truant"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.7.8"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/kylebowen/truant"
  spec.metadata["changelog_uri"] = "https://github.com/kylebowen/truant/blob/main/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  spec.files = Dir["lib/**/*"]
  spec.bindir = "exe"
  spec.executables = ["truant"]
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  spec.add_dependency "thor", "~> 1.3"

  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "standard", "~> 1.3"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
