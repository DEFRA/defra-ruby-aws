# Defra Ruby Aws

![Build Status](https://github.com/DEFRA/defra-ruby-aws/workflows/CI/badge.svg?branch=main)
[![Maintainability Rating](https://sonarcloud.io/api/project_badges/measure?project=DEFRA_defra-ruby-aws&metric=sqale_rating)](https://sonarcloud.io/dashboard?id=DEFRA_defra-ruby-aws)
[![Coverage](https://sonarcloud.io/api/project_badges/measure?project=DEFRA_defra-ruby-aws&metric=coverage)](https://sonarcloud.io/dashboard?id=DEFRA_defra-ruby-aws)
[![security](https://hakiri.io/github/DEFRA/defra-ruby-aws/main.svg)](https://hakiri.io/github/DEFRA/defra-ruby-aws/main)
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
    region: "eu-west-2",
    # optional - Default to false. Will use AES256
    encrypt_with_kms: true
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

### Delete a file from the bucket

```ruby
bucket = DefraRuby::Aws.get_bucket("defra-ruby-aws")
response = bucket.delete("test-upload-file.csv")

if response.successful?
  # Do something
else
  response.error # return the failure error
  # Do something else
end
```

## Contributing to this project

If you have an idea you'd like to contribute please log an issue.

All contributions should be submitted via a pull request.

## License

THIS INFORMATION IS LICENSED UNDER THE CONDITIONS OF THE OPEN GOVERNMENT LICENCE found at:

<http://www.nationalarchives.gov.uk/doc/open-government-licence/version/3>

The following attribution statement MUST be cited in your products and applications when using this information.

> Contains public sector information licensed under the Open Government license v3

### About the license

The Open Government Licence (OGL) was developed by the Controller of Her Majesty's Stationery Office (HMSO) to enable information providers in the public sector to license the use and re-use of their information under a common open licence.

It is designed to encourage use and re-use of information freely and flexibly, with only a few conditions.
