require "rails_helper"

RSpec.feature "Adding a user to an Organisation" do
  let!(:user) { create :user }
  let!(:organisation) { create :organisation }

  before do
    login_as_user user.email, user.password
  end

  context "as a User with an admin permission" do
    before do
      FactoryGirl.create :membership, user: user, organisation: organisation, permissions: { roles: "admin" }
    end

    specify "Creating a user" do
      new_user = FactoryGirl.build :user

      visit organisation_path(organisation)
      click_link "New user"

      fill_in_user_form_with new_user
      fill_in_user_password new_user.password

      check "Admin"

      click_button "Create user"

      assert_user_rendered new_user
    end

    specify "Creating a user that already exists in a different organisation" do
      new_user = FactoryGirl.create :user
      new_organisation = FactoryGirl.create :organisation
      FactoryGirl.create :membership, organisation: new_organisation, user: new_user

      visit organisation_path(organisation)
      click_link "New user"

      fill_in_user_form_with new_user
      fill_in_user_password "12345678"

      click_button "Create user"

      expect(current_path).to eq(organisation_users_path(organisation))
      expect(page).to have_content "You need to fix the errors on this page before continuing"
      expect(page).to have_link "Click here to add #{new_user.email} to #{organisation.name}"

      click_link "Click here to add #{new_user.email} to #{organisation.name}"

      expect(current_path).to eq(new_organisation_membership_path(organisation))
      expect(page).to have_content "New membership to #{organisation.name}"
      expect(page).to have_content "User: #{new_user.name} (#{new_user.email})"

      click_button "Create membership"

      expect(current_path).to eq(organisation_path(organisation))
      expect(page).to have_content("Membership successfully created")

      within ".members" do
        expect(page).to have_link(new_user.name, href: user_path(new_user))
      end
    end

    specify "Creating a user that already exists in the organisation" do
      new_user = FactoryGirl.create :user
      FactoryGirl.create :membership, organisation: organisation, user: new_user

      visit organisation_path(organisation)
      click_link "New user"

      fill_in_user_form_with new_user
      fill_in_user_password "12345678"

      click_button "Create user"

      expect(current_path).to eq(organisation_users_path(organisation))
      expect(page).to have_content "You need to fix the errors on this page before continuing"
      expect(page).to have_content "#{new_user.email} is already a member of #{organisation.name}"
    end

    specify "errors are shown if a user cannot be created" do
      new_user = FactoryGirl.build :user, name: ""

      visit organisation_path(organisation)
      click_link "New user"

      fill_in_user_form_with new_user

      click_button "Create user"

      expect(page).to have_content "You need to fix the errors on this page before continuing"
      expect(page).to have_content "Name: can't be blank"
    end
  end

  context "as a User without an admin permission" do
    specify "gets redirected back to the root_path with an error message" do
      visit new_organisation_user_path(organisation)

      expect(current_path).to eq(root_path)
      expect(page).to have_content "You are not authorized to do that"
    end
  end
end


