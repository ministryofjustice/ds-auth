require "rails_helper"

RSpec.feature "Removing a Users from an Organisation" do
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
        click_link "Delete membership"
      end

      expect(current_path).to eq(organisation_path(organisation))

      expect(page).to have_content("Membership successfully deleted")
      within ".members" do
        expect(page).not_to have_content(other_user.name)
      end
    end
  end
end
