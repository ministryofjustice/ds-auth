require "rails_helper"

RSpec.describe BaseSerializer do
  describe "#as_json" do
    class TestSerializer < BaseSerializer
      def serialize
        "test #serialize response"
      end
    end

    let(:user) { create :user }

    subject { TestSerializer.new user }

    it "creates a root key and calls serialize on the extended serializer" do
      expect(subject.as_json).to eq ({
        user: "test #serialize response"
      })
    end
  end

  describe "#serialize" do
    let(:user) { double("user") }

    subject { BaseSerializer.new user }

    it "should raise an error" do
      expect { subject.serialize }.to raise_error(NotImplementedError)
    end
  end
end
