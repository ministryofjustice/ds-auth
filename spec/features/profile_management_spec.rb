require "rails_helper"

RSpec.feature "Users managing profiles" do
  let(:user) { create(:user) }
  let!(:profile) { create(:profile) }

  before do
    login_as_user user.email
  end

  specify "can view a list of all profiles" do
    visit profiles_path
    expect(page).to have_content "Profiles"
    expect(page).to have_content profile.name
  end

  specify "Associated user toggles associated user password and confirmation", js: true do
    visit profiles_path
    click_link "New Profile"

    expect(page).to_not have_css("#profile_user_attributes_password")
    expect(page).to_not have_css("#profile_user_attributes_password_confirmation")

    check "Associated user"

    expect(page).to have_css("#profile_user_attributes_password")
    expect(page).to have_css("#profile_user_attributes_password_confirmation")
  end

  specify "can create a new profile without an assoicated user" do
    visit profiles_path
    click_link "New Profile"

    fill_in "Name", with: "Eamonn Holmes"
    fill_in "Tel", with: "01632 960178"
    fill_in "Mobile", with: "07700 900407"
    fill_in "Address", with: "123 Fake Street"
    fill_in "Postcode", with: "POSTCODE"
    fill_in "Email", with: "eamonn.holmes@example.xxx"

    click_button "Create Profile"

    within "#profile_#{Profile.last.id}" do
      expect(page).to have_content "Eamonn Holmes"
      expect(page).to_not have_link "User"
    end
  end

  specify "can create a new profile with an assoicated user" do
    visit profiles_path
    click_link "New Profile"

    fill_in "Name", with: "Eamonn Holmes"
    fill_in "Tel", with: "01632 960178"
    fill_in "Mobile", with: "07700 900407"
    fill_in "Address", with: "123 Fake Street"
    fill_in "Postcode", with: "POSTCODE"
    fill_in "Email", with: "eamonn.holmes@example.xxx"
    check "Associated user"

    fill_in "Password", with: "passwordyword"
    fill_in "Password confirmation", with: "passwordyword"

    click_button "Create Profile"

    within "#profile_#{Profile.last.id}" do
      expect(page).to have_content "Eamonn Holmes"
      expect(page).to have_link "Change Password"
    end
  end

  specify "are shown errors if a profile cannot be created" do
    visit profiles_path
    click_link "New Profile"

    fill_in "Name", with: ""
    fill_in "Tel", with: "01632 960178"
    fill_in "Mobile", with: "07700 900407"
    fill_in "Address", with: "123 Fake Street"
    fill_in "Postcode", with: "POSTCODE"
    fill_in "Email", with: "eamonn.holmes@example.xxx"

    click_button "Create Profile"

    expect(page).to have_content "You need to fix the errors on this page before continuing"
    expect(page).to have_content "Name: can't be blank"
  end

  context "destroy" do
    specify "can delete a profile" do
      visit profiles_path

      within "#profile_#{profile.id}" do
        click_link "Delete"
      end

      expect(page).to have_content "Profile successfully deleted"
      expect(page).to_not have_content profile.name
    end

    let!(:profile_with_user) { create(:profile, :with_user) }

    specify "deleting a profile with an associated user destroys the user" do
      user_id = profile_with_user.user.id
      profile_id = profile_with_user.id

      visit profiles_path

      within "#profile_#{profile_with_user.id}" do
        click_link "Delete"
      end

      expect(Profile.where(id: profile_id)).to_not exist
      expect(User.where(id: user_id)).to_not exist

      expect(page).to have_content "Profile successfully deleted"
      expect(page).to_not have_content profile_with_user.name
    end
  end

  specify "are shown errors if an profile cannot be deleted" do
    visit profiles_path

    profile_cannot_be_destroyed_for_some_reason profile

    click_link "Delete"

    expect(page).to have_content "Profile was not deleted"
    expect(page).to have_content profile.name
  end

  specify "can edit relevant details for the profile" do
    visit profiles_path

    click_link "Edit"

    fill_in "Name", with: "DJ Jazzy Jeff"

    click_button "Update Profile"
    expect(page).to have_content "Profile successfully updated"
    expect(page).to have_content "DJ Jazzy Jeff"
  end

  specify "are shown errors if invalid details are entered" do
    visit profiles_path

    click_link "Edit"

    fill_in "Name", with: ""
    click_button "Update Profile"

    expect(page).to have_content "You need to fix the errors on this page before continuing"
    expect(page).to have_content "Name: can't be blank"
  end
end

def profile_cannot_be_destroyed_for_some_reason(profile)
  expect(Profile).to receive(:find).with(profile.id.to_s) { profile }
  expect(profile).to receive(:destroy) { false }
end
