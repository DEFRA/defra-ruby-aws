# frozen_string_literal: true

module DefraRuby
  module Aws
    class Bucket
      attr_reader :bucket_name, :credentials, :region, :encrypt_with_kms

      def initialize(configs)
        @credentials = configs[:credentials]
        @bucket_name = configs[:name]
        @region = setup_region(configs[:region])
        @encrypt_with_kms = setup_encrypt_with_kms(configs[:encrypt_with_kms])

        validate!
      end

      def access_key_id
        credentials[:access_key_id]
      end

      def secret_access_key
        credentials[:secret_access_key]
      end

      def encryption_type
        @_encryption_type ||= @encrypt_with_kms ? "aws:kms" : :AES256
      end

      def load(file, options = {})
        BucketLoaderService.run(self, file, options)
      end

      def presigned_url(file_name, options = {})
        PresignedUrlService.run(self, file_name, options)
      end

      def delete(file_name, options = {})
        DeleteFileFromBucketService.run(self, file_name, options)
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

      def setup_encrypt_with_kms(encrypt_with_kms)
        return false if encrypt_with_kms.nil?

        # Handle the argument being either a string or a boolean, or some other
        # value e.g. "foo"
        encrypt_with_kms.to_s.downcase == "true"
      end

      def validate!
        validate_presence_of_name!
        validate_presence_of_credentials!
      end

      def validate_presence_of_name!
        raise_not_valid_name if bucket_name.nil? || bucket_name.empty?
      end

      def validate_presence_of_credentials!
        raise_missing_credentials if empty?(credentials)
        raise_missing_access_key if empty?(access_key_id)
        raise_missing_secret_access_key if empty?(secret_access_key)
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

      def empty?(object)
        object.nil? || object.empty?
      end
    end
  end
end
