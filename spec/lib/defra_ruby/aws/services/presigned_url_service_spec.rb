# frozen_string_literal: true

require "spec_helper"

module DefraRuby
  module Aws
    RSpec.describe PresignedUrlService do
      describe ".run" do
        let(:configs) do
          {
            name: "test",
            credentials: {
              access_key_id: "123",
              secret_access_key: "Secret"
            }
          }
        end
        let(:bucket) { Bucket.new(configs) }
        let(:presigned_url) { described_class.run(bucket, "testfile.csv") }

        it "returns a presigned url for a given file in the bucket" do
          expect(presigned_url).to include(
            "https://test.s3.eu-west-1.amazonaws.com/testfile.csv",
            "response-content-disposition=attachment", "response-content-type=text%2Fcsv",
            "Amz-Expires", "Amz-Credential", "Amz-Signature"
          )
        end

        context "when an s3_directory is provided" do
          let(:presigned_url) { described_class.run(bucket, "testfile.csv", { s3_directory: "directory" }) }

          it "returns a presigned url for a given file in the bucket" do
            expect(presigned_url).to include(
              "https://test.s3.eu-west-1.amazonaws.com/directory/testfile.csv",
              "response-content-disposition=attachment", "response-content-type=text%2Fcsv",
              "Amz-Expires", "Amz-Credential", "Amz-Signature"
            )
          end
        end
      end
    end
  end
end
