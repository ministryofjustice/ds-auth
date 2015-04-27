require "rails_helper"

RSpec.describe "Users managing permissions" do
  let!(:role) { create(:role) }
  let!(:application) { create(:doorkeeper_application) }
  let!(:organisation) { create(:organisation, :with_profiles_and_users, profile_count: 3) }
  let!(:user) { create(:user, profile: organisation.profiles.first) }
  let!(:permission) { create(:permission, user: user, organisation: organisation) }

  before do
    login_as_user user.email
  end

  specify "can create a new permission for a profile that has a user" do
    visit organisation_path(organisation)

    within "##{user.profile.id}-row" do
      click_link "New Permission"
    end

    expect(page).to have_content organisation.name
    expect(page).to have_content user.email

    select role.name
    select application.name

    click_button "Create Permission"

    expect(page).to have_content "Permission successfully created"
    expect(current_path).to eq organisation_path(organisation)

    within "##{user.profile.id}-row" do
      expect(page).to have_content user.profile.name
      expect(page).to have_content permission.application.name
      expect(page).to have_content permission.role.name
    end
  end

  specify "are shown a message if the permission cannot be created (eg, trying to create a duplicate permission)" do
    visit organisation_path(organisation)

    within "##{organisation.profiles.first.id}-row" do
      click_link "New Permission"
    end

    select permission.role.name
    select permission.application.name
    click_button "Create Permission"

    expect(page).to have_content "You need to fix the errors on this page before continuing."
  end

  specify "can delete permissions from the index page"  do
    visit permissions_path

    click_link "Delete"

    expect(page).to have_content "Permission successfully deleted"
  end

  specify "are shown a message if the permission cannot be deleted"  do
    visit permissions_path

    permission_cannot_be_destroyed_for_some_reason permission

    click_link "Delete"

    expect(page).to have_content "Permission was not deleted"
  end

end

def permission_cannot_be_destroyed_for_some_reason permission
  expect(Permission).to receive(:find).with(permission.id.to_s) { permission }
  expect(permission).to receive(:destroy) { false }
end
