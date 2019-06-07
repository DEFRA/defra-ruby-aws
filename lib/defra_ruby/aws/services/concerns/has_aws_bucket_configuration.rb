# frozen_string_literal: true

module DefraRuby
  module Aws
    module HasAwsBucketConfiguration
      def s3_bucket
        s3.bucket(bucket.bucket_name)
      end

      def s3
        ::Aws::S3::Resource.new(
          region: bucket.region,
          credentials: aws_credentials
        )
      end

      def aws_credentials
        ::Aws::Credentials.new(bucket.access_key_id, bucket.secret_access_key)
      end
    end
  end
end
