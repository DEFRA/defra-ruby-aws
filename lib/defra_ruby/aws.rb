# frozen_string_literal: true

require_relative "aws/bucket"
require_relative "aws/response"
require_relative "aws/configuration"

require_relative "aws/services/concerns/has_aws_bucket_configuration"
require_relative "aws/services/bucket_loader_service"
require_relative "aws/services/presigned_url_service"
require_relative "aws/services/delete_file_from_bucket_service"
require_relative "aws/services/list_bucket_files_service"

module DefraRuby
  module Aws
    class << self
      attr_accessor :configuration

      def configure
        require "aws-sdk-s3"

        self.configuration ||= Configuration.new
        yield(configuration)
      end

      def get_bucket(bucket_name)
        configuration.buckets.select do |bucket|
          bucket.bucket_name == bucket_name
        end.first
      end
    end
  end
end
