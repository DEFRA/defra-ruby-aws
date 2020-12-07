# frozen_string_literal: true

module DefraRuby
  module Aws
    class DeleteFileFromBucketService
      include HasAwsBucketConfiguration

      def self.run(bucket, file_name, options = {})
        new(bucket, file_name, options).run
      end

      def initialize(bucket, file_name, options)
        @bucket = bucket
        @file_name = file_name
        @dir = options[:s3_directory]
      end

      def run
        Response.new(response_exe)
      end

      private

      attr_reader :bucket, :file_name, :dir

      def response_exe
        lambda do
          delete_object_output = s3_bucket.object(destination).delete

          delete_object_output.request_charged.length.positive?
        end
      end

      def destination
        [*dir, file_name].compact.join("/")
      end
    end
  end
end
