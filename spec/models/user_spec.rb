require "rails_helper"

RSpec.describe User do
  let(:user){ create :user }
  let(:role) { Role.create(name: "super-danger-admin") }

  describe "associations" do
    specify { expect(subject).to have_one(:profile) }
    specify { expect(subject).to have_many(:permissions) }
  end

  describe "delegation" do
    specify { expect(subject).to delegate_method(:name).to(:profile) }
  end

  describe "#roles_for" do
    let(:application) { build :doorkeeper_application }
    let(:role) { build :role }

    it "raises an error without an application" do
      expect { subject.roles_for }.to raise_error(ArgumentError)
    end

    it "returns an empty array when user has no roles for the given application" do
      expect(subject.roles_for(application: application)).to eq([])
    end

    it "returns the roles a user has for the given application" do
      expect(subject.permissions).to receive(:for_application).with(application).and_return [double("Permission", role: role)]
      expect(subject.roles_for(application: application)).to eq([role])
    end
  end
end
