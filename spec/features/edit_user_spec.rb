require "rails_helper"

RSpec.shared_examples "editing a User" do
  specify "Editing a user" do
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

RSpec.feature "Editing a user" do
  let(:user) { create(:user, organisations: [organisation]) }
  let(:organisation) { create :organisation }

  before do
    login_as_user current_user.email, current_user.password
  end

  context "as a User that owns the Profile" do
    let!(:current_user) { user }
    include_examples "editing a User"
  end

  context "as a User with an admin permission for the organisation the Profile belongs to" do
    let!(:current_user) { create :user }

    before do
      FactoryGirl.create :membership, user: current_user, organisation: organisation, permissions: { roles: "admin" }
    end

    include_examples "editing a User"
  end

  context "as a User without an admin permission trying to edit another Users profile" do
    let!(:current_user) { create(:user, organisations: [organisation]) }

    specify "gets redirected back to the root_path with an error message" do
      visit edit_user_path(user)

      expect(current_path).to eq(root_path)
      expect(page).to have_content "You are not authorized to do that"
    end
  end
end


