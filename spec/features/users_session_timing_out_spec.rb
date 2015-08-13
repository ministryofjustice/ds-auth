require "rails_helper"

RSpec.feature "Users session timing out" do
  let!(:user) { create(:user) }


  specify "sessions remain active within the timeout period (#{Settings.devise.session_timeout} minutes)" do
    user_is_logged_in user

    Timecop.travel((Settings.devise.session_timeout - 2).minutes.from_now) do
      visit "/"

      expect(current_path).to eq("/")
    end
  end

  specify "sessions expire after (#{Settings.devise.session_timeout} minutes) and require User to log in again" do
    user_is_logged_in user

    Timecop.travel((Settings.devise.session_timeout + 2).minutes.from_now) do
      visit "/"

      expect(current_path).to eq(new_user_session_path)
      expect(page).to have_content("Your session expired. Please sign in again to continue.")
    end
  end
end


def user_is_logged_in(user)
  visit new_user_session_path
  fill_in "user_email", with: user.email
  fill_in "user_password", with: user.password
  click_button "Log in"
end
