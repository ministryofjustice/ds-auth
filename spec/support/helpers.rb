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

  def fill_in_new_user_form_with(user)
    visit users_path
    click_link "New user"
    fill_in_user_form_with user
  end

  def fill_in_edit_user_form_with(old_user, new_user)
    visit users_path
    within "tr#user_#{old_user.id}" do
      click_link "Edit"
    end
    fill_in_user_form_with new_user
  end

  def fill_in_user_form_with(user)
    fill_in "Name", with: user.name
    fill_in "Email", with: user.email
    fill_in "Telephone", with: user.telephone
    fill_in "Mobile", with: user.mobile
    fill_in "Address", with: user.address
    fill_in "Postcode", with: user.postcode
  end

  def fill_in_user_password(password)
    fill_in "Password", with: password
    fill_in "Password confirmation", with: password
  end

  def assert_user_rendered(user)
    expect(page).to have_content(user.name)
    expect(page).to have_content(user.email)
    expect(page).to have_content(user.telephone)
    expect(page).to have_content(user.mobile)
    expect(page).to have_content(user.address)
    expect(page).to have_content(user.postcode)
  end
end
