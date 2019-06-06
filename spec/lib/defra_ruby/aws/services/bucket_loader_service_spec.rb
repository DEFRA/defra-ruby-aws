# frozen_string_literal: true

require "spec_helper"

module DefraRuby
  module Aws
    RSpec.describe BucketLoaderService do
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

        it "loads the given file to the s3 bucket" do
          aws_resource = double(:aws_resource)
          s3_bucket = double(:s3_bulk_bucket)
          file = double(:file, path: "foo/bar/baz/test.csv")
          s3_object = double(:s3_object)
          result = double(:result)

          expect(::Aws::S3::Resource).to receive(:new).and_return(aws_resource)
          expect(aws_resource).to receive(:bucket).with("bulk").and_return(s3_bucket)
          expect(s3_bucket).to receive(:object).with("test.csv").and_return(s3_object)
          expect(s3_object).to receive(:upload_file).with("foo/bar/baz/test.csv", server_side_encryption: :AES256).and_return(result)

          expect(described_class.run(bucket, file)).to eq(result)
        end
      end
    end
  end
end
