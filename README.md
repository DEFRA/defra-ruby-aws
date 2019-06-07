# DefraRuby::Aws

[![Build Status](https://travis-ci.com/DEFRA/defra-ruby-aws.svg?branch=master)](https://travis-ci.com/DEFRA/defra-ruby-aws)

DEFRA AWS helpers for connecting Rails application to the DEFRA AWS instances.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'defra_ruby_aws'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install defra_ruby_aws

## Configuration

Add a new bucket with:

```
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

```
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
