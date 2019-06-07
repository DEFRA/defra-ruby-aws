# frozen_string_literal: true

module DefraRuby
  module Aws
    class Response
      attr_reader :error

      def initialize(response_exe)
        @success = true
        @error = nil

        capture_response(response_exe)
      end

      def successful?
        success
      end

      private

      attr_reader :success

      def capture_response(response_exe)
        response_exe.call
      rescue StandardError => e
        @error = e
        @success = false
      end
    end
  end
end
