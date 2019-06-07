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
          expect(presigned_url).to include("https://test.s3.eu-west-1.amazonaws.com/testfile.csv")
          expect(presigned_url).to include("response-content-disposition=attachment")
          expect(presigned_url).to include("response-content-type=text%2Fcsv")
          expect(presigned_url).to include("Amz-Expires")
          expect(presigned_url).to include("Amz-Credential")
          expect(presigned_url).to include("Amz-Signature")
        end
      end
    end
  end
end
