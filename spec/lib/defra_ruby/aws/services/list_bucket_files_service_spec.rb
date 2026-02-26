# frozen_string_literal: true

require "spec_helper"

module DefraRuby
  module Aws
    RSpec.describe ListBucketFilesService do
      describe "#run" do
        let(:configs) do
          { credentials: { access_key_id: "key_id", secret_access_key: "secret" }, name: "bulk" }
        end
        let(:bucket) { Bucket.new(configs) }
        let(:s3_bucket) { instance_double(::Aws::S3::Bucket) }

        before do
          aws_resource = instance_double(::Aws::S3::Resource)
          allow(::Aws::S3::Resource).to receive(:new).and_return(aws_resource)
          allow(aws_resource).to receive(:bucket).with("bulk").and_return(s3_bucket)
        end

        context "when an s3_directory is provided" do
          let(:first_object) { instance_double(::Aws::S3::ObjectSummary, key: "object1") }
          let(:second_object) { instance_double(::Aws::S3::ObjectSummary, key: "object2") }

          before do
            allow(s3_bucket).to receive(:objects)
              .with(prefix: "/a_directory").and_return([first_object, second_object])
          end

          it "returns a successful response" do
            response = described_class.run(bucket, "/a_directory", {})

            expect(response).to be_successful
          end

          it "returns the file keys" do
            response = described_class.run(bucket, "/a_directory", {})

            expect(response.result).to contain_exactly("object1", "object2")
          end
        end

        context "when an s3_directory is not provided" do
          before do
            allow(s3_bucket).to receive(:objects).with(prefix: nil).and_return(nil)
          end

          it "returns a non successful response" do
            response = described_class.run(bucket, nil)

            expect(response).not_to be_successful
          end

          it "returns a nil result" do
            response = described_class.run(bucket, nil)

            expect(response.result).to be_nil
          end
        end
      end
    end
  end
end
