require "rails_helper"

RSpec.describe OrganisationPolicy do
  let(:organisation) { FactoryGirl.create :organisation }
  let(:user) { FactoryGirl.create :user }

  before do
    FactoryGirl.create :membership, user: user, organisation: organisation
  end

  context "a User not in the Organisation" do
    let(:other_user) { FactoryGirl.create :user }

    subject { OrganisationPolicy.new other_user, organisation }

    it { is_expected.not_to permit_action(:show) }
    it { is_expected.not_to permit_action(:edit) }
    it { is_expected.not_to permit_action(:update) }
    it { is_expected.not_to permit_action(:new) }
    it { is_expected.not_to permit_action(:create) }
    it { is_expected.not_to permit_action(:destroy) }
    it { is_expected.not_to permit_action(:manage_members) }
  end

  context "user is a membership in the organisation" do
    subject { OrganisationPolicy.new user, organisation }

    it { is_expected.to permit_action(:show) }

    it { is_expected.not_to permit_action(:edit) }
    it { is_expected.not_to permit_action(:update) }
    it { is_expected.not_to permit_action(:new) }
    it { is_expected.not_to permit_action(:create) }
    it { is_expected.not_to permit_action(:destroy) }
    it { is_expected.not_to permit_action(:manage_members) }
  end

  context "organisation admin from the organisation" do
    let(:admin_user) { FactoryGirl.create :user }

    subject { OrganisationPolicy.new admin_user, organisation }

    before do
      FactoryGirl.create :membership, user: admin_user, organisation: organisation, permissions: { roles: ["admin"] }
    end

    it { is_expected.to permit_action(:show) }
    it { is_expected.to permit_action(:edit) }
    it { is_expected.to permit_action(:update) }
    it { is_expected.to permit_action(:manage_members) }

    it { is_expected.not_to permit_action(:new) }
    it { is_expected.not_to permit_action(:create) }
    it { is_expected.not_to permit_action(:destroy) }
  end
end
