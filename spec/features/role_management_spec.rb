require 'rails_helper'

RSpec.feature 'Users managing roles' do
  let(:user) { create(:user) }
  let!(:role) { create(:role) }

  before do
    login_as_user user.email
  end

  specify 'can view a list of all roles' do
    visit roles_path
    expect(page).to have_content "Roles"
    expect(page).to have_content role.name
  end

  specify 'can create a new role' do
    visit roles_path
    click_link "New Role"

    fill_in "Name", with: "common-pleb"
    click_button "Create Role"

    expect(page).to have_content "Role successfully created"
    expect(page).to have_content "common-pleb"
  end

  specify 'are shown errors if a role cannot be created' do
    visit roles_path
    click_link "New Role"

    click_button "Create Role"

    expect(page).to have_content "You need to fix the errors on this page before continuing"
    expect(page).to have_content "Name: can't be blank"
  end

  specify 'can delete a role' do
    visit roles_path
    click_link "Delete"

    expect(page).to have_content "Role successfully deleted"
    expect(page).to_not have_content role.name
  end

  specify 'are shown errors if a role cannot be created' do
    visit roles_path

    role_cannot_be_destroyed_for_some_reason role
    click_link "Delete"

    expect(page).to have_content "Role was not deleted"
    expect(page).to have_content role.name
  end
end

def role_cannot_be_destroyed_for_some_reason role
  expect(Role).to receive(:find).with(role.id.to_s) { role }
  expect(role).to receive(:destroy) { false }
end
