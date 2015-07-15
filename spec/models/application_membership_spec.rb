require "rails_helper"

RSpec.describe ApplicationMembership, type: :model do
  describe "associations" do
    specify { expect(subject).to belong_to(:application).class_name("Doorkeeper::Application") }
    specify { expect(subject).to belong_to(:membership) }
  end

  describe "validations" do
    it { expect(subject).to validate_presence_of :application }
    it { expect(subject).to validate_presence_of :membership }

    describe "application" do
      let(:application) { build_stubbed :doorkeeper_application }
      let(:membership) { build_stubbed :membership }

      before do
        subject.application = application
        subject.membership = membership
      end

      context "the membership has access to the application" do
        it "does not add a validation error" do
          expect(membership).to receive(:has_access_to_application?).with(application).and_return true
          subject.valid?
          expect(subject.errors[:application]).to be_empty
        end
      end

      context "the membership does not have access to the application" do
        it "adds a validation error" do
          expect(membership).to receive(:has_access_to_application?).with(application).and_return false
          subject.valid?
          expect(subject.errors[:application]).not_to be_empty
        end
      end
    end
  end

  describe "#application_name" do
    it "returns application.name" do
      subject.application = build :doorkeeper_application, name: "test app"
      expect(subject.application_name).to eq("test app")
    end

    it "returns nil when application is nil" do
      subject.application = nil
      expect(subject.application_name).to be_nil
    end
  end

  describe "#has_roles?" do
    it "returns true if there are roles" do
      subject.roles = ["beastmaster"]
      expect(subject.has_roles?).to be_truthy
    end

    it "returns false if there are no roles" do
      subject.roles = []
      expect(subject.has_roles?).to be_falsey
    end
  end
end
