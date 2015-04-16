require "rails_helper"

RSpec.describe BaseSerializer do
  describe "#as_json" do
    class TestSerializer < BaseSerializer
      def serialize
        "test #serialize response"
      end
    end

    let(:profile) { create :profile }

    subject { TestSerializer.new profile }

    it "creates a root key and calls serialize on the extended serializer" do
      expect(subject.as_json).to eq ({
        profile: "test #serialize response"
      })
    end
  end

  describe "#serialize" do
    let(:profile) { double("profile") }

    subject { BaseSerializer.new profile }

    it "should raise an error" do
      expect { subject.serialize }.to raise_error(NotImplementedError)
    end
  end
end
