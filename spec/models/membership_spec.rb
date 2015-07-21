require "rails_helper"

RSpec.describe Membership, type: :model do
  describe "associations" do
    specify { expect(subject).to belong_to(:organisation) }
    specify { expect(subject).to belong_to(:user) }
  end

  describe "validations" do
    it { expect(subject).to validate_presence_of :user }
    it { expect(subject).to validate_presence_of :organisation }

    it "validates uniqueness_of user+organisation" do
      create :membership, user: create(:user), organisation: create(:organisation)
      expect(subject).to validate_uniqueness_of(:user_id).scoped_to(:organisation_id)
    end
  end

  describe "#roles_for_application" do
    let!(:application) { create :doorkeeper_application, available_roles: ["beastmaster"]}

    it "returns the roles the membership has for the given application" do
      organisation = create :organisation
      application.organisations << organisation
      application.save!
      membership = create :membership, organisation: organisation
      create :application_membership, membership: membership, application: application, roles: application.available_roles

      expect(membership.roles_for_application(application)).to eq(application.available_roles)
    end

    it "returns [] when the membership does not include the given application" do
      expect(subject.roles_for_application(application)).to be_empty
    end
  end
end
