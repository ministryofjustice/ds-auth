require "rails_helper"

RSpec.describe User do
  let(:user){ create :user }


  describe "associations" do
    specify { expect(subject).to have_many(:organisations).through(:memberships) }
    specify { expect(subject).to have_many(:memberships) }
  end

  describe "#roles_names_for" do
    let!(:application) { build :doorkeeper_application }
    let!(:membership) { create :membership, user: user, permissions: { roles: ["admin"]} }

    it "raises an error without an application" do
      expect { user.role_names_for }.to raise_error(ArgumentError)
    end

    it "returns an empty array when user has no roles for the given application" do
      allow(application).to receive(:available_role_names).and_return []
      expect(user.role_names_for(application: application)).to eq([])
    end

    it "returns the roles a user has for the given application" do
      allow(application).to receive(:available_role_names).and_return ["admin"]
      expect(user.role_names_for(application: application)).to eq(["admin"])
    end
  end

  describe "deleting a User" do
    let!(:user) { FactoryGirl.create :user }

    it "removes all associated permissions" do
      FactoryGirl.create :membership, user: user
      expect { user.destroy }.to change(Membership, :count).from(1).to(0)
    end
  end
end
