# frozen_string_literal: true

module DefraRuby
  module Aws
    class BucketLoaderService
      include HasAwsBucketConfiguration

      def self.run(bucket, file, options = {})
        new(bucket, file, options).run
      end

      def initialize(bucket, file, options)
        @bucket = bucket
        @file = file
        @dir = options[:s3_directory]
      end

      def run
        Response.new(response_exe)
      end

      private

      attr_reader :bucket, :file, :dir

      def response_exe
        lambda do
          transfer_manager.upload_file(
            file.path,
            bucket: bucket.bucket_name,
            key: destination,
            server_side_encryption: bucket.encryption_type
          )
        end
      end

      def transfer_manager
        ::Aws::S3::TransferManager.new(client: s3_client)
      end

      def s3_client
        ::Aws::S3::Client.new(
          region: bucket.region,
          credentials: aws_credentials
        )
      end

      def destination
        [*dir, File.basename(file.path)].compact.join("/")
      end
    end
  end
end
