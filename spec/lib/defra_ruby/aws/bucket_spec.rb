# frozen_string_literal: true

require "spec_helper"

module DefraRuby
  module Aws
    RSpec.describe Bucket do
      subject(:bucket) { described_class.new(configs) }

      describe "#initialize" do
        context "when a name configuration is missing" do
          let(:configs) {
            {
              name: nil,
              credentials: "12345"
            }
          }

          it "raises an error" do
            expect { bucket }.to raise_error("DefraRuby::Aws buckets configurations: missing bucket name")
          end
        end

        context "when credentials configuration is missing" do
          let(:configs) {
            {
              name: "foo",
              credentials: ""
            }
          }

          it "raises an error" do
            expect { bucket }.to raise_error("DefraRuby::Aws buckets configurations: missing credentials for bucket foo")
          end
        end
      end

      describe "#load" do
        let(:configs) { { credentials: "secret", name: "bulk" } }

        it "loads the given file to the s3 bucket" do
          aws_resource = double(:aws_resource)
          s3_bucket = double(:s3_bulk_bucket)
          file = double(:file, path: "foo/bar/baz/test.csv")
          s3_object = double(:s3_object)
          result = double(:result)

          expect(::Aws::S3::Resource).to receive(:new).with(region: "eu-west-1", credentials: "secret").and_return(aws_resource)
          expect(aws_resource).to receive(:bucket).with("bulk").and_return(s3_bucket)
          expect(s3_bucket).to receive(:object).with("test.csv").and_return(s3_object)
          expect(s3_object).to receive(:upload_file).with("foo/bar/baz/test.csv", server_side_encryption: :AES256).and_return(result)

          expect(bucket.load(file)).to eq(result)
        end
      end
    end
  end
end
