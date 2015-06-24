require "rails_helper"

RSpec.feature "Creating Organisations" do
  let!(:user) { create :user }

  before do
    login_as_user user.email, user.password
  end

  specify "users cannot create organisations" do
    visit new_organisation_path

    expect(current_path).to eq(root_path)
    expect(page).to have_content "You are not authorized to do that"
  end
end


