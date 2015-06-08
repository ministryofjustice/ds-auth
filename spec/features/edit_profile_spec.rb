require "rails_helper"

RSpec.feature "Editing a profile" do
  let(:user) { create(:user) }
  let!(:profile) { create(:profile) }

  before do
    login_as_user user.email, user.password
  end

  specify "Editing a Profile that cannot log in" do
    new_profile = FactoryGirl.build :profile

    fill_in_edit_profile_form_with profile, new_profile

    click_button "Update Profile"

    assert_profile_rendered new_profile
    expect(page).to have_content("This user cannot login")
  end

  specify "Edit a Profile to add a password so the user can log in", js: true do
    new_profile = FactoryGirl.build :profile
    new_user = FactoryGirl.build :user

    fill_in_edit_profile_form_with profile, new_profile

    check "Can login?"
    fill_in "Password", with: new_user.password
    fill_in "Password confirmation", with: new_user.password

    click_button "Update Profile"

    assert_profile_rendered new_profile
    expect(page).to have_content("This user can login")
  end

  specify "Edit a Profile to change an existing password redirects to user edit page" do
    profile = create :profile, :with_user

    visit profiles_path
    within "tr#profile_#{profile.id}" do
      click_link "Edit"
    end

    within "form.edit_profile" do
      click_link "Change Password"
    end

    expect(current_path).to eq(edit_user_path(profile.user))
  end

  specify "errors are shown if a profile cannot be updated" do
    new_profile = FactoryGirl.build :profile, name: ""

    fill_in_edit_profile_form_with profile, new_profile

    click_button "Update Profile"

    expect(page).to have_content "You need to fix the errors on this page before continuing"
    expect(page).to have_content "Name: can't be blank"
  end
end


