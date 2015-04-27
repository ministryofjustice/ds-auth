module HelperMethods
  def login_as_user(email, password="password")
    visit new_user_session_path
    fill_in "user_email", with: email
    fill_in "user_password", with: password
    click_button "Sign in"
  end

  def sign_out
    click_link("Sign out")
  end
end
