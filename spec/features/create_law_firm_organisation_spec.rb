require "rails_helper"

RSpec.feature "Creating law firm type organisations" do
  let!(:user) { FactoryGirl.create :user }
  let!(:webops_organisation) { FactoryGirl.create :organisation, organisation_type: "webops"}
  let!(:organisation) { create(:organisation) }

  before do
    FactoryGirl.create :membership, user: user, organisation: webops_organisation, permissions: { roles: ["support"] }
    login_as_user user.email, user.password
  end

  specify "can create a new law firm with a supplier number", js: true do
    visit organisations_path

    click_link "New organisation"

    fill_in "Name", with: "my law firm"
    fill_in "Slug", with: "my-law-firm"

    select "Law firm", from: "Organisation type"

    fill_in "Supplier number", with: "AABBCC12345678"

    click_button "Create organisation"

    expect(page).to have_content "Organisation successfully created"
    expect(page).to have_content "my law firm"
    expect(page).to have_content "Supplier number: AABBCC12345678"
  end
end
