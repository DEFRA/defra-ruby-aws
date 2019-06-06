# frozen_string_literal: true

module DefraRuby
  module Aws
    class << self
      attr_accessor :configuration
    end

    def self.configure
      self.configuration ||= Configuration.new
      yield(configuration)
    end

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
