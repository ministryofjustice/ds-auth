require 'rails_helper'

RSpec.feature 'Users managing users' do
  let(:user) { create(:user) }
  let!(:other_user) { create(:user) }

  before do
    login_as_user user.email
  end

  specify 'can view a list of all users except the current user' do
    visit users_path
    expect(page).to have_content "Users"
    expect(page).not_to have_content user.email
    expect(page).to have_content other_user.email
  end

  specify 'can create a new user' do
    visit users_path
    click_link "New User"

    fill_in "Email", with: "eamonn.holmes@example.com"
    fill_in "Password", with: "password"
    fill_in "Password confirmation", with: "password"

    click_button "Create User"

    expect(page).to have_content "User successfully created"
    expect(page).to have_content "eamonn.holmes@example.com"
  end

  specify 'errors are shown if a user cannot be created' do
    visit users_path
    click_link "New User"

    fill_in "Email", with: "eamonn.holmes@example.com"

    click_button "Create User"

    expect(page).to have_content "You need to fix the errors on this page before continuing"
    expect(page).to have_content "Password: can't be blank"
  end

  specify 'can delete a user' do
    visit users_path

    click_link 'Delete'

    expect(page).to have_content 'User successfully deleted'
    expect(page).not_to have_content other_user.email
  end

  specify 'are shown errors if a user cannot be destroyed' do
    visit users_path

    user_cannot_be_destroyed_for_some_reason other_user
    click_link 'Delete'

    expect(page).to have_content 'User was not deleted'
    expect(page).to have_content other_user.email
  end

  specify "can edit the user's password" do
    visit users_path

    click_link 'Edit'

    fill_in 'Password', with: "NEW PASSWORD"
    fill_in 'Password confirmation', with: "NEW PASSWORD"

    click_button 'Update User'

    expect(page).to have_content "User successfully updated"

    sign_out

    login_as_user other_user.email, "NEW PASSWORD"

    expect(page).to have_content('You made it...')
  end

  specify 'are shown errors if the password cannot be changed' do
    visit users_path

    click_link 'Edit'

    fill_in 'Password', with: "NEW PASSWORD"
    fill_in 'Password confirmation', with: "NEW kuafhsdf"

    click_button 'Update User'

    expect(page).to have_content "You need to fix the errors on this page before continuing"
    expect(page).to have_content "Password Confirmation: doesn't match Password"

    sign_out

    login_as_user other_user.email, "NEW PASSWORD"
  end
end

def user_cannot_be_destroyed_for_some_reason user
  expect(User).to receive(:find).with(user.id.to_s) { user }
  expect(user).to receive(:destroy) { false }
end
