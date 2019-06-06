# frozen_string_literal: true

require "spec_helper"

module DefraRuby
  module Aws
    RSpec.describe Bucket do
      subject(:bucket) { described_class.new(configs) }

      describe "#initialize" do
        context "when a name configuration is missing" do
          let(:configs) do
            {
              name: nil,
              credentials: "12345"
            }
          end

          it "raises an error" do
            expect { bucket }.to raise_error("DefraRuby::Aws buckets configurations: missing bucket name")
          end
        end

        context "when credentials configuration is missing" do
          let(:configs) do
            {
              name: "foo",
              credentials: ""
            }
          end

          it "raises an error" do
            expect { bucket }.to raise_error("DefraRuby::Aws buckets configurations: missing credentials for bucket foo")
          end
        end
      end

      describe "#load" do
        let(:configs) do
          {
            name: "foo",
            credentials: "secret"
          }
        end

        it "loads the given file to the s3 bucket" do
          result = double(:result)
          file = double(:file)

          expect(BucketLoaderService).to receive(:run).with(bucket, file).and_return(result)
          expect(bucket.load(file)).to eq(result)
        end
      end
    end
  end
end
