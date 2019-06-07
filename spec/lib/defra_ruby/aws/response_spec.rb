# frozen_string_literal: true

require "spec_helper"

module DefraRuby
  module Aws
    RSpec.describe Response do
      subject(:response) { described_class.new(response_exe) }

      describe "#successful?" do
        context "when the response throws an error" do
          let(:response_exe) { -> { raise "Boom!" } }

          it "returns false" do
            expect(response).to_not be_successful
          end
        end

        context "when the response don't throw an error" do
          let(:response_exe) { -> {} }

          it "returns true" do
            expect(response).to be_successful
          end
        end
      end

      describe "#error" do
        context "when the response throws an error" do
          let(:response_exe) { -> { raise StandardError, "Boom!" } }

          it "returns the error" do
            expect(response.error).to be_a(StandardError)
          end
        end

        context "when the response don't throw an error" do
          let(:response_exe) { -> {} }

          it "returns a nil object" do
            expect(response.error).to be_nil
          end
        end
      end
    end
  end
end
