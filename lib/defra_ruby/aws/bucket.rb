# frozen_string_literal: true

module DefraRuby
  module Aws
    class Bucket
      attr_reader :bucket_name, :credentials, :region

      def initialize(configs)
        @credentials = configs[:credentials]
        @bucket_name = configs[:name]
        @region = setup_region(configs[:region])

        validate!
      end

      def load(file)
        BucketLoaderService.run(self, file)
      end

      private

      attr_writer :region

      def setup_region(region)
        return default_region if region.nil? || region.empty?

        region
      end

      def default_region
        "eu-west-1"
      end

      def validate!
        validate_presence_of_name!
        validate_presence_of_credentials!
      end

      def validate_presence_of_name!
        raise_not_valid_name if bucket_name.nil? || bucket_name.empty?
      end

      def validate_presence_of_credentials!
        raise_not_valid_credentials if credentials.nil? || credentials.empty?
      end

      def raise_not_valid_credentials
        raise("DefraRuby::Aws buckets configurations: missing credentials for bucket #{bucket_name}")
      end

      def raise_not_valid_name
        raise("DefraRuby::Aws buckets configurations: missing bucket name")
      end
    end
  end
end
