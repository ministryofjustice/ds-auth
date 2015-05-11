require "rails_helper"

RSpec.feature "Users managing users" do
  let!(:profile) { create(:profile, :with_user) }
  let!(:other_user) { create(:user) }


  before do
    login_as_user other_user.email
  end

  specify "can edit the user's password" do
    visit profiles_path

    within "#profile_#{profile.id}" do
      click_link "Change Password"
    end

    fill_in "Password", with: "NEW PASSWORD"
    fill_in "Password confirmation", with: "NEW PASSWORD"

    click_button "Update User"

    expect(page).to have_content "User successfully updated"

    sign_out

    login_as_user profile.user.email, "NEW PASSWORD"

    expect(page).to have_content("You made it...")
  end

  specify "are shown errors if the password cannot be changed" do
    visit profiles_path

    within "#profile_#{profile.id}" do
      click_link "Change Password"
    end

    fill_in "Password", with: "NEW PASSWORD"
    fill_in "Password confirmation", with: "NEW kuafhsdf"

    click_button "Update User"

    expect(page).to have_content "You need to fix the errors on this page before continuing"
    expect(page).to have_content "Password confirmation: doesn't match Password"

    sign_out

    login_as_user other_user.email, "NEW PASSWORD"
  end
end

def user_cannot_be_destroyed_for_some_reason(user)
  expect(User).to receive(:find).with(user.id.to_s) { user }
  expect(user).to receive(:destroy) { false }
end
