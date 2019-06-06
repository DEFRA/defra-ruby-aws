# frozen_string_literal: true

lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require_relative "./lib/defra_ruby"
require_relative "./lib/defra_ruby/aws/version"

Gem::Specification.new do |spec|
  spec.name          = "defra-ruby-aws"
  spec.version       = DefraRuby::Aws::VERSION
  spec.authors       = ["Defra"]
  spec.email         = ["cintamani.puddu@gmail.com"]

  spec.summary       = "DEFRA Aws helpers"
  spec.description   = "DEFRA AWS helpers for connecting Rails application to the DEFRA AWS instances."
  spec.homepage      = "https://github.com/DEFRA/defra-ruby-aws"
  spec.license       = "The Open Government Licence (OGL) Version 3"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["homepage_uri"] = spec.homepage
    spec.metadata["source_code_uri"] = spec.homepage
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  # Use the AWS SDK to interact with S3
  spec.add_dependency "aws-sdk-s3"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.test_files = Dir["spec/**/*"]
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.17"

  spec.add_development_dependency "defra_ruby_style"
  # Shim to load environment variables from a .env file into ENV
  spec.add_development_dependency "dotenv"
  # Allows us to automatically generate the change log from the tags, issues,
  # labels and pull requests on GitHub. Added as a dependency so all dev's have
  # access to it to generate a log, and so they are using the same version.
  # New dev's should first create GitHub personal app token and add it to their
  # ~/.bash_profile (or equivalent)
  # https://github.com/skywinder/github-changelog-generator#github-token
  spec.add_development_dependency "github_changelog_generator"
  spec.add_development_dependency "pry-byebug"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "rubocop"
  spec.add_development_dependency "simplecov"
end
