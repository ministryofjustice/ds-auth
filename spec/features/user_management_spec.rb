require "rails_helper"

RSpec.feature "Users managing users" do
  let!(:user) { create(:user) }
  let!(:other_user) { create(:user) }


  before do
    login_as_user other_user.email, other_user.password
  end

  specify "can edit the user's password" do
    visit users_path

    within "#user_#{user.id}" do
      click_link "Edit"
    end

    fill_in "Password", with: "NEW PASSWORD"
    fill_in "Password confirmation", with: "NEW PASSWORD"

    click_button "Update user"

    expect(page).to have_content "User successfully updated"

    sign_out

    login_as_user user.email, "NEW PASSWORD"

    expect(current_path).to eq(root_path)
  end

  specify "are shown errors if the password cannot be changed" do
    visit users_path

    within "#user_#{user.id}" do
      click_link "Edit"
    end

    fill_in "Password", with: "NEW PASSWORD"
    fill_in "Password confirmation", with: "NEW kuafhsdf"

    click_button "Update user"

    expect(page).to have_content "You need to fix the errors on this page before continuing"
    expect(page).to have_content "Password confirmation: doesn't match Password"
  end
end

def user_cannot_be_destroyed_for_some_reason(user)
  expect(User).to receive(:find).with(user.id.to_s) { user }
  expect(user).to receive(:destroy) { false }
end
