require "rails_helper"

RSpec.feature "User logging in" do
  let!(:user) { create(:user) }

  specify "can log in with valid credentials" do
    visit new_user_session_path
    fill_in "user_email", with: user.email
    fill_in "user_password", with: user.password
    click_button "Sign in"

    expect(current_path).to eq(root_path)
  end

  specify "cannot log in with invalid credentials" do
    visit new_user_session_path
    fill_in "user_email", with: user.email
    fill_in "user_password", with: "notarealpassword"
    click_button "Sign in"

    expect(current_path).to eq(new_user_session_path)
  end

  specify "receives a message when missing credentials for login" do
    visit new_user_session_path
    fill_in "user_email", with: user.email
    click_button "Sign in"

    expect(current_path).to eq(new_user_session_path)
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

  specify "after logging in User has links to all Applications they have access to" do
    application = create :doorkeeper_application, name: "test app", redirect_uri: "http://foobar.example.org/oauth/callback", handles_own_authorization: true
    organisation = create :organisation, applications: [application]
    membership = create :membership, user: user, organisation: organisation
    create :application_membership, application: application, membership: membership, can_login: true

    user_is_logged_in user

    expect(current_path).to eq(root_path)
    expect(page).to have_content("You have access to these applications:")
    expect(page).to have_link("test app", href: "http://foobar.example.org/")
  end
end

def number_of_active_oauth_tokens_for(user)
  Doorkeeper::AccessToken.where(resource_owner_id: user.id, revoked_at: nil).count
end

def user_is_logged_in(user)
  visit new_user_session_path
  fill_in "user_email", with: user.email
  fill_in "user_password", with: user.password
  click_button "Sign in"
end
