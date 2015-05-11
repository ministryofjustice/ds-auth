require "rails_helper"

RSpec.feature "User authentication" do
  let!(:user) { create(:user) }

  specify "can log in with valid credentials" do
    visit new_user_session_path
    fill_in "user_email", with: user.email
    fill_in "user_password", with: "password"
    click_button "Sign in"
    expect(page).to have_content("You made it...")
  end

  specify "cannot log in with invalid credentials" do
    visit new_user_session_path
    fill_in "user_email", with: user.email
    fill_in "user_password", with: "notarealpassword"
    click_button "Sign in"
    expect(page).to_not have_content("You made it...")
  end

  specify "receives a message when missing credentials for login" do
    visit new_user_session_path
    fill_in "user_email", with: user.email
    click_button "Sign in"
    expect(page).to have_content("Invalid email or password")
  end

  context "signed in to multiple oauth applications" do
    let!(:user) { create :user,
                  :logged_in_to_applications,
                  number_of_applications: 2 }

    specify "has all oauth tokens revoked on sign out" do
      user_is_logged_in user

      expect(number_of_active_oauth_tokens_for user).to eq 2

      click_link "Sign out"

      expect(number_of_active_oauth_tokens_for user).to eq 0
    end
  end
end

def number_of_active_oauth_tokens_for(user)
  Doorkeeper::AccessToken.where(resource_owner_id: user.id, revoked_at: nil).count
end

def user_is_logged_in(user)
  visit new_user_session_path
  fill_in "user_email", with: user.email
  fill_in "user_password", with: "password"
  click_button "Sign in"
end
