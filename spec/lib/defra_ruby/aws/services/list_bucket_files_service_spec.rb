# frozen_string_literal: true

require "spec_helper"

module DefraRuby
  module Aws
    RSpec.describe ListBucketFilesService do
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

        context "when an s3_directory is provided" do
          it "returns a successful response" do
            aws_resource = double(:aws_resource)
            s3_bucket = double(:s3_bulk_bucket)
            s3_object1 = double(:s3_object)
            s3_object2 = double(:s3_object)
            s3_objects = [s3_object1, s3_object2]
            s3_directory = "/a_directory"
            options = {}

            expect(::Aws::S3::Resource).to receive(:new).and_return(aws_resource)
            expect(aws_resource).to receive(:bucket).with("bulk").and_return(s3_bucket)
            expect(s3_bucket).to receive(:objects).with(prefix: s3_directory).and_return(s3_objects)
            expect(s3_object1).to receive(:key).and_return("object1").at_least(:once)
            expect(s3_object2).to receive(:key).and_return("object2").at_least(:once)

            response = described_class.run(bucket, s3_directory, options)
            expect(response).to be_successful
            expect(response.result).to match_array([s3_object1.key, s3_object2.key])
          end
        end

        context "when an s3_directory is not provided" do
          it "returns a non successful response" do
            aws_resource = double(:aws_resource)
            s3_bucket = double(:s3_bulk_bucket)
            s3_directory = nil

            expect(::Aws::S3::Resource).to receive(:new).and_return(aws_resource)
            expect(aws_resource).to receive(:bucket).with("bulk").and_return(s3_bucket)
            expect(s3_bucket).to receive(:objects).with(prefix: s3_directory).and_return(nil)

            response = described_class.run(bucket, s3_directory)
            expect(response).to_not be_successful
            expect(response.result).to be_nil
          end
        end
      end
    end
  end
end
