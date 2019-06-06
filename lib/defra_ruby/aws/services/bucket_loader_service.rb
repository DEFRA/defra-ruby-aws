# frozen_string_literal: true

module DefraRuby
  module Aws
    class BucketLoaderService
      def self.run(bucket, file)
        new(bucket, file).run
      end

      def initialize(bucket, file)
        @bucket = bucket
        @file = file
      end

      def run
        s3_bucket.object(File.basename(file.path)).upload_file(file.path, server_side_encryption: :AES256)
      end

      private

      attr_reader :bucket, :file

      def s3_bucket
        s3.bucket(bucket.bucket_name)
      end

      def s3
        ::Aws::S3::Resource.new(
          region: bucket.region,
          credentials: aws_credentials #bucket.credentials
        )
      end

      def aws_credentials
        ::Aws::Credentials.new(bucket.access_key_id, bucket.secret_access_key)
      end
    end
  end
end
