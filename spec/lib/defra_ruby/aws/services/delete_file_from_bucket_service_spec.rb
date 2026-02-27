# frozen_string_literal: true

require "spec_helper"

module DefraRuby
  module Aws
    RSpec.describe DeleteFileFromBucketService do
      describe "#run" do
        let(:configs) do
          { credentials: { access_key_id: "key_id", secret_access_key: "secret" }, name: "bulk" }
        end
        let(:bucket) { Bucket.new(configs) }
        let(:s3_bucket) { instance_double(::Aws::S3::Bucket) }
        let(:s3_object) { instance_double(::Aws::S3::Object) }

        before do
          aws_resource = instance_double(::Aws::S3::Resource)
          allow(::Aws::S3::Resource).to receive(:new).and_return(aws_resource)
          allow(aws_resource).to receive(:bucket).with("bulk").and_return(s3_bucket)
          allow(s3_bucket).to receive(:object).and_return(s3_object)
          allow(s3_object).to receive(:delete).and_return(result)
        end

        context "when the delete succeeds" do
          let(:result) { Struct.new(:request_charged).new("present") }

          it "returns a successful response" do
            response = described_class.run(bucket, "test.csv")

            expect(response).to be_successful
          end

          context "when an s3_directory is provided" do
            it "returns a successful response" do
              response = described_class.run(bucket, "test.csv", s3_directory: "directory")

              expect(response).to be_successful
            end

            it "uses the correct object path" do
              described_class.run(bucket, "test.csv", s3_directory: "directory")

              expect(s3_bucket).to have_received(:object).with("directory/test.csv")
            end
          end
        end

        context "when the response body returns an empty charged requests" do
          let(:result) { Struct.new(:request_charged).new("") }

          it "returns a non successful response" do
            response = described_class.run(bucket, "test.csv")

            expect(response).not_to be_successful
          end

          context "when an s3_directory is provided" do
            it "returns a non successful response" do
              response = described_class.run(bucket, "test.csv", s3_directory: %w[directory second_directory])

              expect(response).not_to be_successful
            end

            it "uses the correct object path" do
              described_class.run(bucket, "test.csv", s3_directory: %w[directory second_directory])

              expect(s3_bucket).to have_received(:object).with("directory/second_directory/test.csv")
            end
          end
        end
      end
    end
  end
end
