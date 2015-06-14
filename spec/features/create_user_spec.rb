require "rails_helper"

RSpec.feature "Creating a user" do
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

      fill_in_new_user_form_with new_user

      fill_in_user_password new_user.password

      click_button "Create user"

      assert_user_rendered new_user
    end

    specify "errors are shown if a user cannot be created" do
      new_user = FactoryGirl.build :user, name: ""

      fill_in_new_user_form_with new_user

      click_button "Create user"

      expect(page).to have_content "You need to fix the errors on this page before continuing"
      expect(page).to have_content "Name: can't be blank"
    end
  end

  context "as a User without an admin permission" do
    specify "gets redirected back to the root_path with an error message" do
      visit new_user_path

      expect(current_path).to eq(root_path)
      expect(page).to have_content "You are not authorized to do that"
    end
  end
end


