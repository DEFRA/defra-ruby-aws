# frozen_string_literal: true

require "spec_helper"

RSpec.describe "Defra Ruby AWS" do
  before { configure_gem }

  it "Upload a file to an AWS bucket" do
    stub_successful_request

    bucket = DefraRuby::Aws.get_bucket("bulk-test")
    response = bucket.load(Tempfile.new("test-bucket-load.test"))

    expect(response).to be_successful
  end

  it "fails gracefully", :aggregate_failures do
    stub_failing_request

    bucket = DefraRuby::Aws.get_bucket("bulk-test")
    response = bucket.load(Tempfile.new("test-bucket-load.test"))

    expect(response).not_to be_successful
    expect(response.error).to be_a(Aws::S3::Errors::Forbidden)
  end

  def configure_gem
    DefraRuby::Aws.configure do |config|
      config.buckets = [{
        name: "bulk-test",
        credentials: {
          access_key_id: "ACCESS_KEY_ID",
          secret_access_key: "SECRET_ACCESS_KEY"
        }
      }]
    end
  end

  def stub_successful_request
    stub_request(:put, %r{https://bulk-test\.s3\.eu-west-1\.amazonaws\.com/test-bucket-load\..+})
  end

  def stub_failing_request
    stub_request(
      :put,
      %r{https://bulk-test\.s3\.eu-west-1\.amazonaws\.com/test-bucket-load\..+}
    ).to_return(
      status: 403
    )
  end
end
