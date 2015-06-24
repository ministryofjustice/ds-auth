require "rails_helper"

RSpec.feature "Creating Organisations" do
  let!(:user) { create :user }
  let!(:organisation) { create :organisation }

  before do
    login_as_user user.email, user.password
  end

  specify "admin users for the Organisation can update it" do
    create :membership, user: user, organisation: organisation, permissions: { roles: "admin" }

    visit edit_organisation_path(organisation)

    expect(current_path).to eq(edit_organisation_path(organisation))

    fill_in "Name", with: "Ministry of Justice"
    fill_in "Tel", with: "09011105010"
    fill_in "Address", with: "Somewhere"
    fill_in "Postcode", with: "555 PQ45"
    fill_in "Email", with: "moj@example.com"

    click_button "Update organisation"

    expect(current_path).to eq(organisation_path(organisation))
    expect(page).to have_content "Organisation successfully updated"
    expect(page).to have_content "Name: Ministry of Justice"
    expect(page).to have_content "Tel: 09011105010"
    expect(page).to have_content "Address: Somewhere"
    expect(page).to have_content "Postcode: 555 PQ45"
    expect(page).to have_content "Email: moj@example.com"
  end

  specify "are shown errors if invalid details are entered" do
    create :membership, user: user, organisation: organisation, permissions: { roles: "admin" }

    visit edit_organisation_path(organisation)

    expect(current_path).to eq(edit_organisation_path(organisation))

    fill_in "Name", with: ""
    click_button "Update organisation"

    expect(page).to have_content "You need to fix the errors on this page before continuing"
    expect(page).to have_content "Name: can't be blank"
  end

  specify "users that belong to the Organisation cannot update it" do
    create :membership, user: user, organisation: organisation

    visit edit_organisation_path(organisation)

    expect(current_path).to eq(root_path)
    expect(page).to have_content "You are not authorized to do that"
  end

  specify "admin users for other Organisations cannot update it" do
    other_organisation = create :organisation
    create :membership, user: user, organisation: other_organisation, permissions: { roles: "admin" }

    visit edit_organisation_path(organisation)

    expect(page).to have_content "The page you were looking for doesn't exist"
  end

  specify "users not belonging to the organisation cannot update it" do
    visit edit_organisation_path(organisation)

    expect(page).to have_content "The page you were looking for doesn't exist"
  end
end


