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

  def fill_in_new_profile_form_with(profile)
    visit profiles_path
    click_link "New Profile"
    fill_in_profile_form_with profile
  end

  def fill_in_edit_profile_form_with(old_profile, new_profile)
    visit profiles_path
    within "tr#profile_#{old_profile.id}" do
      click_link "Edit"
    end
    fill_in_profile_form_with new_profile
  end

  def fill_in_profile_form_with(profile)
    fill_in "Name", with: profile.name
    fill_in "Email", with: profile.email
    fill_in "Tel", with: profile.tel
    fill_in "Mobile", with: profile.mobile
    fill_in "Address", with: profile.address
    fill_in "Postcode", with: profile.postcode
  end

  def assert_profile_rendered(profile)
    expect(page).to have_content(profile.name)
    expect(page).to have_content(profile.email)
    expect(page).to have_content(profile.tel)
    expect(page).to have_content(profile.mobile)
    expect(page).to have_content(profile.address)
    expect(page).to have_content(profile.postcode)
  end
end
