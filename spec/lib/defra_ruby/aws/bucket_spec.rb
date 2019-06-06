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
              credentials: {}
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
              credentials: {}
            }
          end

          it "raises an error" do
            expect { bucket }.to raise_error("DefraRuby::Aws buckets configurations: missing credentials for bucket foo")
          end
        end

        context "when credentials access key id is missing" do
          let(:configs) do
            {
              name: "foo",
              credentials: {
                secret_access_key: "secret"
              }
            }
          end

          it "raises an error" do
            expect { bucket }.to raise_error("DefraRuby::Aws buckets configurations: missing access key id for bucket foo")
          end
        end

        context "when credentials secret access key is missing" do
          let(:configs) do
            {
              name: "foo",
              credentials: {
                access_key_id: "access_key"
              }
            }
          end

          it "raises an error" do
            expect { bucket }.to raise_error("DefraRuby::Aws buckets configurations: missing secret access key for bucket foo")
          end
        end
      end

      describe "#load" do
        let(:configs) do
          {
            name: "foo",
            credentials: {
              secret_access_key: "secret",
              access_key_id: "access_key"
            }
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
