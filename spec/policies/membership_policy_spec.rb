require "rails_helper"

RSpec.describe MembershipPolicy do
  let(:organisation) { create :organisation }
  let(:membership) { create :membership, organisation: organisation }

  describe MembershipPolicy::Scope do
    it "always returns an empty result" do
      expect(described_class.new(User.new, Membership).resolve).to be_empty
    end
  end

  context "user is a membership in the organisation" do
    let(:user_membership) { create :membership, organisation: organisation  }
    subject { MembershipPolicy.new user_membership.user, membership }

    it { is_expected.not_to permit_action(:show) }
    it { is_expected.not_to permit_action(:edit) }
    it { is_expected.not_to permit_action(:update) }
    it { is_expected.not_to permit_action(:new) }
    it { is_expected.not_to permit_action(:create) }
    it { is_expected.not_to permit_action(:destroy) }
  end

  context "organisation admin from the same organisation" do
    let(:admin_user) { create :user }

    before do
      create :membership, user: admin_user, organisation: organisation, roles: ["admin"]
    end

    subject { MembershipPolicy.new admin_user, membership }

    it { is_expected.not_to permit_action(:show) }
    it { is_expected.to permit_action(:edit) }
    it { is_expected.to permit_action(:update) }

    it { is_expected.to permit_action(:new) }
    it { is_expected.to permit_action(:create) }
    it { is_expected.to permit_action(:destroy) }
  end

  context "webops user" do
    let!(:webops_user) { FactoryGirl.create :user }
    let!(:webops_organisation) { FactoryGirl.create :organisation, organisation_type: "webops"}

    subject { MembershipPolicy.new webops_user, membership }

    before do
      FactoryGirl.create :membership, user: webops_user, organisation: webops_organisation, permissions: { roles: ["support"] }
    end

    it { is_expected.not_to permit_action(:show) }
    it { is_expected.to permit_action(:edit) }
    it { is_expected.to permit_action(:update) }

    it { is_expected.to permit_action(:new) }
    it { is_expected.to permit_action(:create) }
    it { is_expected.to permit_action(:destroy) }
  end
end
