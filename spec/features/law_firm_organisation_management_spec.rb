require "rails_helper"

RSpec.feature "Users managing law firm type organisations" do
  let(:user) { create(:user) }
  let!(:organisation) { create(:organisation) }

  before do
    login_as_user user.email, user.password
  end

  specify "can create a new law firm with a supplier number", js: true do
    visit organisations_path

    click_link "New Organisation"

    fill_in "Name", with: "my law firm"
    fill_in "Slug", with: "my-law-firm"

    select "Law firm", from: "Organisation type"

    fill_in "Supplier number", with: "AABBCC12345678"

    click_button "Create Organisation"

    expect(current_path).to eq(organisations_path)
    expect(page).to have_content "Organisation successfully created"
    expect(page).to have_content "my law firm"

    within "#my-law-firm-row" do
      click_link "Show"
    end

    expect(page).to have_content "Supplier number: AABBCC12345678"
  end
end
