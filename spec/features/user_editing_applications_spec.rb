require "rails_helper"

RSpec.feature "User editing consuming applications" do
  specify "is redirected to login when not logged in" do
    visit oauth_applications_path

    expect(current_path).to eq(new_user_session_path)
  end

  specify "cannot access this area as a non-webops user" do
    user_is_logged_in create(:user)

    visit oauth_applications_path

    expect(current_path).to eq(root_path)
  end

  specify "can access this area as a webops user" do
    user_is_logged_in create(:user, :webops)

    visit oauth_applications_path

    expect(current_path).to eq(oauth_applications_path)
  end
end

def user_is_logged_in(user)
  visit new_user_session_path
  fill_in "user_email", with: user.email
  fill_in "user_password", with: user.password
  click_button "Sign in"
end
