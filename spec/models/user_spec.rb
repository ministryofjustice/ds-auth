require "rails_helper"

RSpec.describe User do
  let(:user){ create :user }

  describe "associations" do
    specify { expect(subject).to have_many(:organisations).through(:memberships) }
    specify { expect(subject).to have_many(:memberships) }
  end

  describe "validations" do
    it { expect(subject).to validate_presence_of :name }
  end

  describe "#member_of?" do
    let!(:organisation) { create :organisation }

    it "returns true when user is a member of the given organisation" do
      create :membership, user: user, organisation: organisation
      expect(user.member_of?(organisation)).to be_truthy
    end

    it "returns false when user is not a member of the given organisation" do
      expect(user.member_of?(organisation)).to be_falsey
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
