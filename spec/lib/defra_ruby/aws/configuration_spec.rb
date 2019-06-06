# frozen_string_literal: true

require "spec_helper"

module DefraRuby
  module Aws
    RSpec.describe Configuration do
      subject(:configuration) { described_class.new }

      describe "#buckets=" do
        let(:buckets) { %i[foo bar baz] }

        it "creates a list of buckets" do
          expect(Bucket).to receive(:new).with(:foo)
          expect(Bucket).to receive(:new).with(:bar)
          expect(Bucket).to receive(:new).with(:baz)

          configuration.buckets = buckets
        end
      end
    end
  end
end
