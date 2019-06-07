# frozen_string_literal: true

module DefraRuby
  module Aws
    class PresignedUrlService
      include HasAwsBucketConfiguration

      def self.run(bucket, file_name)
        new(bucket, file_name).run
      end

      def initialize(bucket, file_name)
        @bucket = bucket
        @file_name = file_name
      end

      def run
        s3_bucket.object(file_name).presigned_url(
          :get,
          expires_in: 20 * 60, # 20 minutes in seconds
          secure: true,
          response_content_type: "text/csv",
          response_content_disposition: "attachment; filename=#{file_name}"
        )
      end

      private

      attr_reader :bucket, :file_name
    end
  end
end
