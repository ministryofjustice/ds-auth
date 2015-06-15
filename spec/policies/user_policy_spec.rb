require "rails_helper"

RSpec.describe UserPolicy do
  let(:organisation) { FactoryGirl.create :organisation }
  let(:user) { FactoryGirl.create :user }

  before do
    FactoryGirl.create :membership, user: user, organisation: organisation
  end

  context "the same User" do
    subject { UserPolicy.new user, user }

    it { is_expected.to permit_action(:show) }
    it { is_expected.to permit_action(:edit) }
    it { is_expected.to permit_action(:update) }

    it { is_expected.not_to permit_action(:new) }
    it { is_expected.not_to permit_action(:create) }
    it { is_expected.not_to permit_action(:destroy) }
  end

  context "another user in the same organisation" do
    let!(:other_user) { FactoryGirl.create :user }
    subject { UserPolicy.new other_user, user }

    before do
      FactoryGirl.create :membership, user: other_user, organisation: organisation
    end

    it { is_expected.to permit_action(:show) }

    it { is_expected.not_to permit_action(:edit) }
    it { is_expected.not_to permit_action(:update) }
    it { is_expected.not_to permit_action(:new) }
    it { is_expected.not_to permit_action(:create) }
    it { is_expected.not_to permit_action(:destroy) }
  end

  context "organisation admin from the same organisation" do
    let(:admin_user) { FactoryGirl.create :user }

    subject { UserPolicy.new admin_user, user }

    before do
      FactoryGirl.create :membership, user: admin_user, organisation: organisation, permissions: { roles: ["admin"] }
    end

    it { is_expected.to permit_action(:show) }
    it { is_expected.to permit_action(:edit) }
    it { is_expected.to permit_action(:update) }

    it { is_expected.to permit_action(:new) }
    it { is_expected.to permit_action(:create) }
    it { is_expected.to permit_action(:destroy) }
  end

  context "organisation admin from a different organisation" do
    let(:admin_user) { FactoryGirl.create :user }

    subject { UserPolicy.new admin_user, user }

    before do
      FactoryGirl.create :membership, user: admin_user, organisation: create(:organisation), permissions: { roles: ["admin"] }
    end

    it { is_expected.not_to permit_action(:show) }
    it { is_expected.not_to permit_action(:edit) }
    it { is_expected.not_to permit_action(:update) }

    it { is_expected.not_to permit_action(:new) }
    it { is_expected.not_to permit_action(:create) }
    it { is_expected.not_to permit_action(:destroy) }
  end

  context "another user not the same organisation" do
    let!(:other_user) { FactoryGirl.create :user }
    subject { UserPolicy.new other_user, user }

    it { is_expected.not_to permit_action(:show) }
    it { is_expected.not_to permit_action(:edit) }
    it { is_expected.not_to permit_action(:update) }
    it { is_expected.not_to permit_action(:new) }
    it { is_expected.not_to permit_action(:create) }
    it { is_expected.not_to permit_action(:destroy) }
  end
end
