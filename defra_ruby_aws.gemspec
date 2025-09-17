# rubocop:disable Gemspec/RequiredRubyVersion
# frozen_string_literal: true

$LOAD_PATH.push File.expand_path("lib", __dir__)

# Maintain your gem"s version:
require "defra_ruby/aws/version"

Gem::Specification.new do |spec|
  spec.name          = "defra_ruby_aws"
  spec.version       = DefraRuby::Aws::VERSION
  spec.authors       = ["Defra"]
  spec.email         = ["alan.cruikshanks@environment-agency.gov.uk"]
  spec.license       = "Open Government Licence v3.0"
  spec.homepage      = "https://github.com/DEFRA/defra-ruby-aws"
  spec.summary       = "Defra ruby on rails AWS helpers"
  spec.description   = "Package of AWS features commonly used in Defra Rails based digital services"

  spec.files = Dir["{bin,config,lib}/**/*", "LICENSE", "Rakefile", "README.md"]
  spec.test_files = Dir["spec/**/*"]

  spec.require_paths = ["lib"]

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "https://rubygems.org"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  # Use the AWS SDK to interact with S3.
  # Pin the version for now to avoid deprecation warning in some services.
  # TODO: Refactor to address the deprecation warning and unpin.
  spec.add_dependency "aws-sdk-s3", "< 1.197"
end

# rubocop:enable Gemspec/RequiredRubyVersion
