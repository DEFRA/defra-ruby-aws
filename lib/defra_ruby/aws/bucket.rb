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

      def access_key_id
        credentials[:access_key_id]
      end

      def secret_access_key
        credentials[:secret_access_key]
      end

      def load(file)
        BucketLoaderService.run(self, file)
      end

      def presigned_url(file_name)
        PresignedUrlService.run(self, file_name)
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
        raise_missing_credentials if credentials.nil? || credentials.empty?
        raise_missing_access_key if access_key_id.nil? || access_key_id.empty?
        raise_missing_secret_access_key if secret_access_key.nil? || secret_access_key.empty?
      end

      def raise_not_valid_name
        raise("DefraRuby::Aws buckets configurations: missing bucket name")
      end

      def raise_missing_credentials
        raise("DefraRuby::Aws buckets configurations: missing credentials for bucket #{bucket_name}")
      end

      def raise_missing_access_key
        raise("DefraRuby::Aws buckets configurations: missing access key id for bucket #{bucket_name}")
      end

      def raise_missing_secret_access_key
        raise("DefraRuby::Aws buckets configurations: missing secret access key for bucket #{bucket_name}")
      end
    end
  end
end
