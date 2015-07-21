require "rails_helper"

RSpec.describe User, "#can_login_to_application?" do

  let!(:user) { create :user }
  let!(:application) { create :doorkeeper_application, available_roles: ["beastmaster"] }
  let(:organisation) { create :organisation }
  let(:membership) { create :membership, organisation: organisation, user: user }

  context "organisation with no access to the application" do
    it "returns no memberships" do
      expect(user.can_login_to_application?(application)).to be_falsey
    end
  end

  context "organisation has access to the application" do
    before do
      application.organisations << organisation
      application.save!
    end

    context "application handles its own authorization" do
      before do
        application.update handles_own_authorization: true
      end

      context "no memberships can login to the application" do
        it "returns no memberships" do
          create :application_membership, application: application, membership: membership, can_login: false
          expect(user.can_login_to_application?(application)).to be_falsey
        end
      end

      context "a membership can login to the application" do
        it "returns that membership" do
          create :application_membership, application: application, membership: membership, can_login: true
          expect(user.can_login_to_application?(application)).to be_truthy
        end
      end
    end

    context "application does not handle its own authorization" do
      before do
        application.update handles_own_authorization: false
      end

      context "no memberships have roles for the application" do
        it "returns no memberships" do
          create :application_membership, application: application, membership: membership, roles: []
          expect(user.can_login_to_application?(application)).to be_falsey
        end
      end

      context "a membership has roles for the application" do
        it "returns that membership" do
          create :application_membership, application: application, membership: membership, roles: application.available_roles
          expect(user.can_login_to_application?(application)).to be_truthy
        end
      end
    end
  end
end
