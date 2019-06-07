# frozen_string_literal: true

module DefraRuby
  module Aws
    class Configuration
      attr_reader :buckets

      def initialize
        @buckets = {}
      end

      def buckets=(buckets_configurations)
        @buckets = buckets_configurations.map do |configs|
          Bucket.new(configs)
        end
      end
    end
  end
end
