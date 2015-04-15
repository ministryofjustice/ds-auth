require "rails_helper"

RSpec.describe CollectionSerializer do
  describe "#as_json" do
    class TestCollectionSerializer < CollectionSerializer
      def serialize
        "test collection #serialize response"
      end

      private

      def root_key
        :testing
      end
    end

    let (:profiles) { create_list :profile, 2 }

    subject { TestCollectionSerializer.new profiles }

    it "calls root_key and serialize on the extending serializer" do
      expect(subject.as_json).to eq({
        testing: "test collection #serialize response"
      })
    end
  end

  describe "#serialize" do
    let(:profiles) { double("profiles") }

    subject { CollectionSerializer.new profiles }

    it "should raise an error" do
      expect { subject.serialize }.to raise_error(NotImplementedError)
    end
  end

  describe "#root_key" do
    let(:profiles) { double("profiles") }

    subject { CollectionSerializer.new profiles }

    it "should raise an error" do
      expect { subject.send(:root_key) }.to raise_error(NotImplementedError)
    end
  end
end
