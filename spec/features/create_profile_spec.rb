require "rails_helper"

RSpec.feature "Creating a profile" do
  let(:user) { create(:user) }
  let!(:profile) { create(:profile) }

  before do
    login_as_user user.email, user.password
  end

  specify "Creating a Profile that cannot log in" do
    new_profile = FactoryGirl.build :profile

    fill_in_new_profile_form_with new_profile

    click_button "Create Profile"

    assert_profile_rendered new_profile
    expect(page).to have_content("This user cannot login")
  end

  specify "Creating a Profile with a password so the user can log in", js: true do
    new_profile = FactoryGirl.build :profile
    new_user = FactoryGirl.build :user

    fill_in_new_profile_form_with new_profile

    check "Can login?"
    fill_in "Password", with: new_user.password
    fill_in "Password confirmation", with: new_user.password

    click_button "Create Profile"

    assert_profile_rendered new_profile
    expect(page).to have_content("This user can login")
  end

  specify "errors are shown if a profile cannot be created" do
    new_profile = FactoryGirl.build :profile, name: ""

    fill_in_new_profile_form_with new_profile

    click_button "Create Profile"

    expect(page).to have_content "You need to fix the errors on this page before continuing"
    expect(page).to have_content "Name: can't be blank"
  end
end


