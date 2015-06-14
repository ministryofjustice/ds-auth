require "rails_helper"

RSpec.feature "Editing a user" do
  let(:user) { create(:user) }

  before do
    login_as_user user.email, user.password
  end

  specify "Editing a user that cannot log in" do
    new_user = FactoryGirl.build :user

    fill_in_edit_user_form_with user, new_user

    click_button "Update user"

    assert_user_rendered new_user
  end

  specify "errors are shown if a user cannot be updated" do
    new_user = FactoryGirl.build :user, name: ""

    fill_in_edit_user_form_with user, new_user

    click_button "Update user"

    expect(page).to have_content "You need to fix the errors on this page before continuing"
    expect(page).to have_content "Name: can't be blank"
  end
end


