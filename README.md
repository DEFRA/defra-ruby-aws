# DefraRuby::Aws

[![Build Status](https://travis-ci.com/DEFRA/defra-ruby-aws.svg?branch=master)](https://travis-ci.com/DEFRA/defra-ruby-aws)
[![Maintainability](https://api.codeclimate.com/v1/badges/4541a29b2c675b03a5ed/maintainability)](https://codeclimate.com/github/DEFRA/defra-ruby-aws/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/4541a29b2c675b03a5ed/test_coverage)](https://codeclimate.com/github/DEFRA/defra-ruby-aws/test_coverage)
[![security](https://hakiri.io/github/DEFRA/defra-ruby-aws/master.svg)](https://hakiri.io/github/DEFRA/defra-ruby-aws/master)
[![Gem Version](https://badge.fury.io/rb/defra_ruby_aws.svg)](https://badge.fury.io/rb/defra_ruby_aws)
[![Licence](https://img.shields.io/badge/Licence-OGLv3-blue.svg)](http://www.nationalarchives.gov.uk/doc/open-government-licence/version/3)

Package of Ruby helpers for connecting Rails applications to AWS S3.

## Installation

Add this line to your application's Gemfile

```ruby
gem 'defra_ruby_aws'
```

And then update your dependencies by calling

```bash
bundle install
```

## Configuration

Add a new bucket with:

```ruby
# config/initializers/defra_ruby_aws.rb
require "defra_ruby/aws"

DefraRuby::Aws.configure do |config|
  config.buckets = [{
    # bucket's name, required
    name: "defra-ruby-aws",
    # AWS bucket access credentials, required
    credentials: {
      access_key_id: "ACCESS_KEY_ID",
      secret_access_key: "SECRET_ACCESS_KEY"
    },
    # optional - Default to "eu-west-1"
    region: "eu-west-1"
  }]
end
```

## Usage

### Upload a file

```ruby
file_to_upload = Tempfile.new("test-upload-file.csv")
bucket = DefraRuby::Aws.get_bucket("defra-ruby-aws")
response = bucket.load(file_to_upload)

if response.successful?
  # Do something
else
  response.error # return the failure error
  # Do something else
end
```

### Generate a presigned URL for download

```ruby
bucket = DefraRuby::Aws.get_bucket("defra-ruby-aws")
presigned_url = bucket.presigned_url("test-upload-file.csv")
```

## Contributing to this project

If you have an idea you'd like to contribute please log an issue.

All contributions should be submitted via a pull request.

## License

THIS INFORMATION IS LICENSED UNDER THE CONDITIONS OF THE OPEN GOVERNMENT LICENCE found at:

http://www.nationalarchives.gov.uk/doc/open-government-licence/version/3

The following attribution statement MUST be cited in your products and applications when using this information.

> Contains public sector information licensed under the Open Government license v3

### About the license

The Open Government Licence (OGL) was developed by the Controller of Her Majesty's Stationery Office (HMSO) to enable information providers in the public sector to license the use and re-use of their information under a common open licence.

It is designed to encourage use and re-use of information freely and flexibly, with only a few conditions.
