require "rails_helper"

RSpec.feature "Editing a Users role in an Organisation" do
  let!(:user) { create :user }
  let!(:other_user) { create :user }
  let!(:organisation) { create :organisation }

  before do
    login_as_user user.email, user.password
  end

  context "as a User with an admin permission" do
    before do
      create :membership, user: user, organisation: organisation, is_organisation_admin: true
    end

    specify "can change the roles a User has in my organisation" do
      membership = create :membership, user: other_user, organisation: organisation

      visit organisation_path(organisation)
      within ".members #membership_#{membership.id}" do
        click_link "Edit"
      end

      expect(current_path).to eq(edit_organisation_membership_path(organisation, membership))

      check "Organisation admin"

      click_button "Update membership"

      expect(current_path).to eq(organisation_path(organisation))

      expect(page).to have_content("Membership successfully updated")
      within ".members #membership_#{membership.id} td:nth-of-type(2)" do
        expect(page).to have_content("✓")
      end
    end

    context "but not a webops" do
      let!(:application){ create :doorkeeper_application, available_roles: ["viewer", "manager", "role user does not have"] }
      let(:app_membership){ create :application_membership, application: application, membership: user.memberships.last, roles: ["viewer", "manager"] }
      let!(:other_user_membership){ create(:membership, user: other_user, organisation: organisation) }
      before do
        user.update_attribute(:is_webops, false)
        organisation.applications << application
        app_membership
      end

      specify "I can give a user all the roles I have" do
        visit edit_organisation_membership_path(organisation, other_user_membership)

        within ".memberships" do
          expect(page).to have_css("label", text: "Viewer")
          expect(page).to have_css("label", text: "Manager")
        end
      end

      context "when the 'can_only_grant_own_roles' feature is enabled" do
        before do
          allow(FeatureFlags::Features).to receive(:enabled?).with("can_only_grant_own_roles").and_return(true)
        end

        specify "I cannot give a user a role I don't have" do
          visit edit_organisation_membership_path(organisation, other_user_membership)

          within ".memberships" do
            expect(page).not_to have_css("label", text: "Role user does not have")
          end
        end
      end

      context "when the 'can_only_grant_own_roles' feature is not enabled" do
        before do
          allow(FeatureFlags::Features).to receive(:enabled?).with("can_only_grant_own_roles").and_return(false)
        end

        specify "I can give a user a role I don't have" do
          visit edit_organisation_membership_path(organisation, other_user_membership)

          within ".memberships" do
            expect(page).to have_css("label", text: "Role user does not have")
          end
        end
      end
    end
  end
end


