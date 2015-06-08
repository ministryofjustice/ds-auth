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
end
