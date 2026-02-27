# frozen_string_literal: true

require "spec_helper"

module DefraRuby
  module Aws
    RSpec.describe Configuration do
      subject(:configuration) { described_class.new }

      describe "#buckets=" do
        let(:buckets) { %i[foo bar baz] }

        before { allow(Bucket).to receive(:new) }

        it "creates a list of buckets", :aggregate_failures do
          configuration.buckets = buckets

          expect(Bucket).to have_received(:new).with(:foo)
          expect(Bucket).to have_received(:new).with(:bar)
          expect(Bucket).to have_received(:new).with(:baz)
        end
      end
    end
  end
end
