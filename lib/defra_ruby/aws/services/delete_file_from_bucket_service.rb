# frozen_string_literal: true

module DefraRuby
  module Aws
    class DeleteFileFromBucketService
      include HasAwsBucketConfiguration

      def self.run(bucket, file_name)
        new(bucket, file_name).run
      end

      def initialize(bucket, file_name)
        @bucket = bucket
        @file_name = file_name
      end

      def run
        Response.new(response_exe)
      end

      private

      attr_reader :bucket, :file_name

      def response_exe
        lambda do
          delete_object_output = s3_bucket.object(file_name).delete

          delete_object_output.request_charged.length > 0
        end
      end
    end
  end
end
