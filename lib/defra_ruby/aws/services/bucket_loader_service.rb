# frozen_string_literal: true

module DefraRuby
  module Aws
    class BucketLoaderService
      include HasAwsBucketConfiguration

      def self.run(bucket, file)
        new(bucket, file).run
      end

      def initialize(bucket, file)
        @bucket = bucket
        @file = file
      end

      def run
        Response.new(response_exe)
      end

      private

      attr_reader :bucket, :file

      def response_exe
        lambda do
          s3_bucket
            .object(File.basename(file.path))
            .upload_file(file.path, server_side_encryption: bucket.encryption_type)
        end
      end
    end
  end
end
