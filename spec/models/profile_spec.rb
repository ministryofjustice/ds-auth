require "rails_helper"

RSpec.describe Profile do

  describe "associations" do
    specify { expect(subject).to belong_to(:user) }
    specify { expect(subject).to have_many(:organisations).through(:memberships) }
  end

  describe "scopes" do
    describe ".by_name" do
      it "returns profiles in alphabetical order" do
        create :profile, name: "First Profile"
        create :profile, name: "Second Profile"
        create :profile, name: "Third Profile"

        expect(Profile.by_name.pluck(:name)).to eq [
          "First Profile",
          "Second Profile",
          "Third Profile"
        ]
      end
    end
  end

  describe "deleting a Profile" do
    let!(:profile) { FactoryGirl.create :profile, :with_user }

    it "removes an associated user" do
      expect { profile.destroy }.to change(User, :count).from(1).to(0)
    end

    it "removes all associated memberships" do
      FactoryGirl.create :membership, profile: profile
      expect { profile.destroy }.to change(Membership, :count).from(1).to(0)
    end
  end
end
