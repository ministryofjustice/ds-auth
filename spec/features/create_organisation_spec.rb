require "rails_helper"

RSpec.feature "Creating Organisations" do
  let!(:user) { create :user }

  before do
    login_as_user user.email, user.password
  end

  context "user is not webops" do
    specify "users cannot create organisations" do
      visit new_organisation_path

      expect(current_path).to eq(root_path)
      expect(page).to have_content "You are not authorized to do that"
    end
  end

  context "user is webops" do
    let!(:user) { FactoryGirl.create :user }
    let!(:webops_organisation) { FactoryGirl.create :organisation, organisation_type: "webops"}

    before do
      FactoryGirl.create :membership, user: user, organisation: webops_organisation, permissions: { roles: ["support"] }
    end

    specify "can create a new organisation" do
      visit organisations_path

      click_link "New organisation"

      fill_in "Name", with: "Imperial College London"
      fill_in "Slug", with: "imperial-college-london"

      expect(page).to have_select("Organisation type")

      select "Drs Call Center", from: "Organisation type"

      check "Searchable"
      fill_in "Tel", with: "01632 960178"
      fill_in "Mobile", with: "07700 900407"
      fill_in "Address", with: "123 Fake Street"
      fill_in "Postcode", with: "POSTCODE"
      fill_in "Email", with: "imperial@example.com"

      click_button "Create organisation"

      expect(page).to have_content "Organisation successfully created"
      expect(page).to have_content "Name: Imperial College London"
      expect(page).to have_content "Slug: imperial-college-london"
      expect(page).to have_content "Tel: 01632 960178"
      expect(page).to have_content "Mobile: 07700 900407"
      expect(page).to have_content "Address: 123 Fake Street"
      expect(page).to have_content "Postcode: POSTCODE"
      expect(page).to have_content "Email: imperial@example.com"
    end

    specify "can create a sub-organisation" do
      organisation = create :organisation

      visit organisations_path

      click_link "New organisation"

      fill_in "Name", with: "Sub Organisation"
      fill_in "Slug", with: "sub-organisation"
      select "Law firm", from: "Organisation type"
      check "Searchable"
      fill_in "Tel", with: "01234 567890"
      fill_in "Mobile", with: "01234 567890"
      fill_in "Address", with: "123 Fake Street"
      fill_in "Postcode", with: "POSTCODE"
      fill_in "Email", with: "suborganisation@example.com"

      expect(page).to have_select("Parent organisation", with_options: ["---", organisation.name])

      select organisation.name, from: "Parent organisation"

      click_button "Create organisation"

      expect(page).to have_content "Organisation successfully created"
      expect(page).to have_content "Name: Sub Organisation"
      expect(page).to have_content "Parent Organisation: #{organisation.name}"
      expect(page).to have_link organisation.name, href: organisation_path(organisation)
    end

    specify "are shown errors if an organisation cannot be created" do
      visit organisations_path

      click_link "New organisation"

      fill_in "Name", with: "LRUG"
      fill_in "Slug", with: "london-ruby-users-group"

      click_button "Create organisation"

      expect(page).to have_content "You need to fix the errors on this page before continuing"
      expect(page).to have_content "Organisation type: can't be blank"
    end
  end
end


