# frozen_string_literal: true

module DefraRuby
  module Aws
    class Bucket
      attr_reader :bucket_name

      def initialize(configs)
        @credentials = configs[:credentials]
        @bucket_name = configs[:name]
        @region = setup_region(configs[:region])

        validate!
      end

      def load(file)
        s3_bucket.object(File.basename(file.path)).upload_file(file.path, server_side_encryption: :AES256)
      end

      private

      attr_reader :credentials, :region
      attr_writer :region

      def setup_region(region)
        if region.nil? || region.length < 1
          default_region
        else
          region
        end
      end

      def default_region
        "eu-west-1"
      end

      def s3_bucket
        @_bucket ||= s3.bucket(bucket_name)
      end

      def s3
        ::Aws::S3::Resource.new(
          region: region,
          credentials: credentials
        )
      end

      def validate!
        validate_presence_of_name!
        validate_presence_of_credentials!
      end

      def validate_presence_of_name!
        if bucket_name.nil? || bucket_name.length < 1
          raise("DefraRuby::Aws buckets configurations: missing bucket name")
        end
      end

      def validate_presence_of_credentials!
        if credentials.nil? || credentials.length < 1
          raise("DefraRuby::Aws buckets configurations: missing credentials for bucket #{bucket_name}")
        end
      end
    end
  end
end
