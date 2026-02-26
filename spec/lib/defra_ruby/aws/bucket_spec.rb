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
          context "when it has not been added to the config" do
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

          context "when its value is an empty string" do
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

        context "when 'encrypt_with_kms' is not set" do
          context "when it has not been added to the config" do
            let(:configs) do
              {
                name: "foo",
                credentials: credentials
              }
            end

            it "defaults encrypt_with_kms to false" do
              expect(bucket.encrypt_with_kms).to be false
            end

            it "sets encryption_type to :AES256" do
              expect(bucket.encryption_type).to eq(:AES256)
            end
          end

          context "when its value is an empty string" do
            let(:configs) do
              {
                name: "foo",
                credentials: credentials,
                encrypt_with_kms: ""
              }
            end

            it "defaults encrypt_with_kms to false" do
              expect(bucket.encrypt_with_kms).to be false
            end

            it "sets encryption_type to :AES256" do
              expect(bucket.encryption_type).to eq(:AES256)
            end
          end
        end

        context "when 'encrypt_with_kms' is set" do
          let(:encrypt_with_kms) { true }
          let(:configs) do
            {
              name: "foo",
              credentials: credentials,
              encrypt_with_kms: encrypt_with_kms
            }
          end

          context "with true as a boolean" do
            let(:encrypt_with_kms) { true }

            it "defaults encrypt_with_kms to true" do
              expect(bucket.encrypt_with_kms).to be true
            end

            it "sets encryption_type to aws:kms" do
              expect(bucket.encryption_type).to eq("aws:kms")
            end
          end

          context "with true as a string" do
            let(:encrypt_with_kms) { "true" }

            it "defaults encrypt_with_kms to true" do
              expect(bucket.encrypt_with_kms).to be true
            end

            it "sets encryption_type to aws:kms" do
              expect(bucket.encryption_type).to eq("aws:kms")
            end
          end

          context "with false as a boolean" do
            let(:encrypt_with_kms) { false }

            it "defaults encrypt_with_kms to false" do
              expect(bucket.encrypt_with_kms).to be false
            end

            it "sets encryption_type to aws:kms" do
              expect(bucket.encryption_type).to eq(:AES256)
            end
          end

          context "with false as a string" do
            let(:encrypt_with_kms) { "false" }

            it "defaults encrypt_with_kms to false" do
              expect(bucket.encrypt_with_kms).to be false
            end

            it "sets encryption_type to aws:kms" do
              expect(bucket.encryption_type).to eq(:AES256)
            end
          end

          context "with something not recognised" do
            let(:encrypt_with_kms) { "bar" }

            it "defaults encrypt_with_kms to false" do
              expect(bucket.encrypt_with_kms).to be false
            end

            it "sets encryption_type to :AES256" do
              expect(bucket.encryption_type).to eq(:AES256)
            end
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
        let(:result) { instance_double(Response) }
        let(:file) { instance_double(File) }
        let(:options) { {} }

        before do
          allow(BucketLoaderService).to receive(:run).with(bucket, file, options).and_return(result)
        end

        it "loads the given file to the s3 bucket", :aggregate_failures do
          expect(bucket.load(file, options)).to eq(result)
          expect(BucketLoaderService).to have_received(:run).with(bucket, file, options)
        end
      end
    end
  end
end
