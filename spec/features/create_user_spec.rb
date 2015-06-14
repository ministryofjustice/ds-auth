require "rails_helper"

RSpec.feature "Creating a user" do
  let(:user) { create(:user) }
  let!(:user) { create(:user) }

  before do
    login_as_user user.email, user.password
  end

  specify "Creating a user" do
    new_user = FactoryGirl.build :user

    fill_in_new_user_form_with new_user

    fill_in_user_password new_user.password

    click_button "Create user"

    assert_user_rendered new_user
  end

  specify "errors are shown if a user cannot be created" do
    new_user = FactoryGirl.build :user, name: ""

    fill_in_new_user_form_with new_user

    click_button "Create user"

    expect(page).to have_content "You need to fix the errors on this page before continuing"
    expect(page).to have_content "Name: can't be blank"
  end
end


