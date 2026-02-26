# frozen_string_literal: true

source "https://rubygems.org"

git_source(:github) { |repo_name| "https://github.com/#{repo_name}" }

# Specify your gem's dependencies in defra-ruby-aws.gemspec
gemspec

group :development, :test do
  # version 1.16.2 has a syntax error
  gem "console", "< 1.16.2"

  # Shim to load environment variables from a .env file into ENV
  gem "dotenv"

  gem "rubocop"
  gem "rubocop-factory_bot"
  gem "rubocop-rake"
  gem "rubocop-rspec"

  gem "defra_ruby_style"
  gem "github_changelog_generator"
  gem "pry-byebug"
  gem "rake"
  gem "rspec", "~> 3.0"
  gem "simplecov", "~> 0.22.0"
  gem "webmock"
end
