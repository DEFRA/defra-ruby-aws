# frozen_string_literal: true

require "spec_helper"

module DefraRuby
  module Aws
    RSpec.describe BucketLoaderService do

      describe "#run" do
        let(:bucket) { Bucket.new(configs) }
        let(:file) { instance_double(File, path: "foo/bar/baz/test.csv") }
        let(:transfer_manager) { instance_double(::Aws::S3::TransferManager) }

        before do
          s3_client = instance_double(::Aws::S3::Client)
          allow(::Aws::S3::Client).to receive(:new).and_return(s3_client)
          allow(::Aws::S3::TransferManager).to receive(:new).with(client: s3_client).and_return(transfer_manager)
          allow(transfer_manager).to receive(:upload_file).and_return(true)
        end

        context "when 'encrypt_with_kms' is not set" do
          let(:configs) { { credentials: { access_key_id: "key_id", secret_access_key: "secret" }, name: "bulk" } }

          it "loads the given file to the s3 bucket using :AES256" do
            described_class.run(bucket, file)

            expect(transfer_manager).to have_received(:upload_file)
              .with("foo/bar/baz/test.csv", bucket: "bulk", key: "test.csv", server_side_encryption: :AES256)
          end

          context "when an s3_directory is provided" do
            it "loads the given file at the correct location" do
              described_class.run(bucket, file, s3_directory: "directory")

              expect(transfer_manager).to have_received(:upload_file)
                .with("foo/bar/baz/test.csv", bucket: "bulk", key: "directory/test.csv", server_side_encryption: :AES256)
            end
          end
        end

        context "when 'encrypt_with_kms' is set" do
          let(:configs) do
            { credentials: { access_key_id: "key_id", secret_access_key: "secret" }, name: "bulk",
              encrypt_with_kms: true }
          end

          it "loads the given file to the s3 bucket using AWS:KMS" do
            described_class.run(bucket, file)

            expect(transfer_manager).to have_received(:upload_file)
              .with("foo/bar/baz/test.csv", bucket: "bulk", key: "test.csv", server_side_encryption: "aws:kms")
          end

          context "when an s3_directory is provided" do
            it "loads the given file at the correct location" do
              described_class.run(bucket, file, s3_directory: %w[directory second_directory])

              expect(transfer_manager).to have_received(:upload_file)
                .with("foo/bar/baz/test.csv", bucket: "bulk", key: "directory/second_directory/test.csv",
                                              server_side_encryption: "aws:kms")
            end
          end
        end
      end
    end
  end
end
