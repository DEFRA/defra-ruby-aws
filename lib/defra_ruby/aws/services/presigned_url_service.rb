# frozen_string_literal: true

module DefraRuby
  module Aws
    class PresignedUrlService
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
        s3_bucket.object(destination).presigned_url(
          :get,
          expires_in: 20 * 60, # 20 minutes in seconds
          secure: true,
          response_content_type: "text/csv",
          response_content_disposition: "attachment; filename=#{file_name}"
        )
      end

      private

      attr_reader :bucket, :file_name, :dir

      def destination
        [*dir, file_name].compact.join("/")
      end
    end
  end
end
