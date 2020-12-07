# frozen_string_literal: true

require "spec_helper"

module DefraRuby
  module Aws
    RSpec.describe DeleteFileFromBucketService do
      describe "#run" do
        let(:configs) do
          {
            credentials: {
              access_key_id: "key_id",
              secret_access_key: "secret"
            },
            name: "bulk"
          }
        end
        let(:bucket) { Bucket.new(configs) }

        it "returns a successful response" do
          aws_resource = double(:aws_resource)
          s3_bucket = double(:s3_bulk_bucket)
          file_name = "test.csv"
          s3_object = double(:s3_object)
          result = double(:result, request_charged: "present")

          expect(::Aws::S3::Resource).to receive(:new).and_return(aws_resource)
          expect(aws_resource).to receive(:bucket).with("bulk").and_return(s3_bucket)
          expect(s3_bucket).to receive(:object).with("test.csv").and_return(s3_object)
          expect(s3_object).to receive(:delete).and_return(result)

          response = described_class.run(bucket, file_name)
          expect(response).to be_successful
        end

        context "when an s3_directory is provided" do
          it "returns a successful response" do
            aws_resource = double(:aws_resource)
            s3_bucket = double(:s3_bulk_bucket)
            file_name = "test.csv"
            s3_object = double(:s3_object)
            result = double(:result, request_charged: "present")
            options = { s3_directory: "directory" }

            expect(::Aws::S3::Resource).to receive(:new).and_return(aws_resource)
            expect(aws_resource).to receive(:bucket).with("bulk").and_return(s3_bucket)
            expect(s3_bucket).to receive(:object).with("directory/test.csv").and_return(s3_object)
            expect(s3_object).to receive(:delete).and_return(result)

            response = described_class.run(bucket, file_name, options)
            expect(response).to be_successful
          end
        end

        context "when the response body returns an empty charged requests" do
          it "returns a non successful response" do
            aws_resource = double(:aws_resource)
            s3_bucket = double(:s3_bulk_bucket)
            file_name = "test.csv"
            s3_object = double(:s3_object)
            result = double(:result, request_charged: "")

            expect(::Aws::S3::Resource).to receive(:new).and_return(aws_resource)
            expect(aws_resource).to receive(:bucket).with("bulk").and_return(s3_bucket)
            expect(s3_bucket).to receive(:object).with("test.csv").and_return(s3_object)
            expect(s3_object).to receive(:delete).and_return(result)

            response = described_class.run(bucket, file_name)
            expect(response).to_not be_successful
          end

          context "when an s3_directory is provided" do
            it "returns a non successful response" do
              aws_resource = double(:aws_resource)
              s3_bucket = double(:s3_bulk_bucket)
              file_name = "test.csv"
              s3_object = double(:s3_object)
              result = double(:result, request_charged: "")
              options = { s3_directory: ["directory", "second_directory"] }

              expect(::Aws::S3::Resource).to receive(:new).and_return(aws_resource)
              expect(aws_resource).to receive(:bucket).with("bulk").and_return(s3_bucket)
              expect(s3_bucket).to receive(:object).with("directory/second_directory/test.csv").and_return(s3_object)
              expect(s3_object).to receive(:delete).and_return(result)

              response = described_class.run(bucket, file_name, options)
              expect(response).to_not be_successful
            end
          end
        end
      end
    end
  end
end
