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

    let (:users) { create_list :user, 2 }

    subject { TestCollectionSerializer.new users }

    it "calls root_key and serialize on the extending serializer" do
      expect(subject.as_json).to eq({
        testing: "test collection #serialize response"
      })
    end
  end

  describe "#serialize" do
    let(:users) { double("users") }

    subject { CollectionSerializer.new users }

    it "should raise an error" do
      expect { subject.serialize }.to raise_error(NotImplementedError)
    end
  end

  describe "#root_key" do
    let(:users) { double("users") }

    subject { CollectionSerializer.new users }

    it "should raise an error" do
      expect { subject.send(:root_key) }.to raise_error(NotImplementedError)
    end
  end
end
