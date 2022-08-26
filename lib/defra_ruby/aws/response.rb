# frozen_string_literal: true

module DefraRuby
  module Aws
    class UnsuccessfulOperation < StandardError; end

    class Response
      attr_reader :error, :result

      def initialize(response_exe)
        @success = true
        @error = nil
        @result = nil

        capture_response(response_exe)
      end

      def successful?
        success
      end

      private

      attr_reader :success

      def capture_response(response_exe)
        @result = response_exe.call
        raise UnsuccessfulOperation unless @result
      rescue StandardError => e
        @error = e
        @success = false
      end
    end
  end
end
