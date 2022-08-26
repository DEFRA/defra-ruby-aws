# frozen_string_literal: true

module DefraRuby
  module Aws
    class ListBucketFilesService
      include HasAwsBucketConfiguration

      def self.run(bucket, folder, options = {})
        new(bucket, folder, options).run
      end

      def initialize(bucket, folder, options)
        @bucket = bucket
        @folder = folder
        @dir = options[:s3_directory]
      end

      def run
        Response.new(response_exe)
      end

      private

      attr_reader :bucket, :dir

      def response_exe
        lambda do
          s3_bucket.objects(prefix: @folder).collect(&:key)
        end
      end
    end
  end
end
