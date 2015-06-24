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
      FactoryGirl.create :membership, user: user, organisation: organisation, permissions: { roles: "admin" }
    end

    specify "Creating a user that already exists in a different organisation" do
      membership = create :membership, user: other_user, organisation: organisation

      visit organisation_path(organisation)
      within ".members #membership_#{membership.id}" do
        click_link "Edit membership"
      end

      expect(current_path).to eq(edit_organisation_membership_path(organisation, membership))

      check "Admin"

      click_button "Update membership"

      expect(current_path).to eq(organisation_path(organisation))

      expect(page).to have_content("Membership successfully updated")
      within ".members #membership_#{membership.id}" do
        expect(page).to have_content("Admin")
      end
    end
  end
end


