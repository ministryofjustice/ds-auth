require 'rails_helper'

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

  specify "can create a new profile" do
    visit profiles_path
    click_link "New Profile"

    fill_in "Name", with: "Eamonn Holmes"
    fill_in "Tel", with: "09011105010"
    fill_in "Address", with: "123 Fake Street"
    fill_in "Postcode", with: "POSTCODE"
    fill_in "Email", with: "eamonn.holmes@example.xxx"

    click_button "Create Profile"

    expect(page).to have_content "Eamonn Holmes"
  end

  specify "are shown errors if a profile cannot be created" do
    visit profiles_path
    click_link "New Profile"

    fill_in "Name", with: ""
    fill_in "Tel", with: "09011105010"
    fill_in "Address", with: "123 Fake Street"
    fill_in "Postcode", with: "POSTCODE"
    fill_in "Email", with: "eamonn.holmes@example.xxx"

    click_button "Create Profile"

    expect(page).to have_content "You need to fix the errors on this page before continuing"
    expect(page).to have_content "Name: can't be blank"
  end

  specify "can delete a profile" do
    visit profiles_path

    click_link "Delete"

    expect(page).to have_content "Profile successfully deleted"
    expect(page).to_not have_content profile.name
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

def profile_cannot_be_destroyed_for_some_reason profile
  expect(Profile).to receive(:find).with(profile.id.to_s) { profile }
  expect(profile).to receive(:destroy) { false }
end