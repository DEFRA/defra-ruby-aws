# frozen_string_literal: true

require "spec_helper"

module DefraRuby
  module Aws
    RSpec.describe Bucket do
      subject(:bucket) { described_class.new(configs) }

      let(:credentials) { { access_key_id: "access_key", secret_access_key: "secret" } }

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

        context "when 'region' is not set" do
          context "because it has not been added to the config" do
            let(:configs) do
              {
                name: "foo",
                credentials: credentials
              }
            end

            it "defaults the region to 'eu-west-1'" do
              expect(bucket.region).to eq("eu-west-1")
            end
          end

          context "because its value is an empty string" do
            let(:configs) do
              {
                name: "foo",
                credentials: credentials,
                region: ""
              }
            end

            it "defaults the region to 'eu-west-1'" do
              expect(bucket.region).to eq("eu-west-1")
            end
          end
        end

        context "when 'region' is set" do
          let(:region) { "eu-west-2" }
          let(:configs) do
            {
              name: "foo",
              credentials: credentials,
              region: region
            }
          end

          it "sets the region to match" do
            expect(bucket.region).to eq(region)
          end
        end
      end

      describe "#load" do
        let(:configs) do
          {
            name: "foo",
            credentials: credentials
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
