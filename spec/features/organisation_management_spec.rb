require "rails_helper"

RSpec.feature "Users managing organisations" do
  let(:user) { create(:user) }
  let!(:organisation) { create(:organisation, :with_profiles_and_users, profile_count: 3) }

  before do
    login_as_user user.email
  end

  specify "can view a list of all organisations" do
    visit organisations_path
    expect(page).to have_content "Organisations"
    expect(page).to have_content organisation.name
  end

  specify "can create a new organisation" do
    visit organisations_path

    click_link "New Organisation"

    fill_in "Name", with: "Imperial College London"
    fill_in "Slug", with: "imperial-college-london"

    expect(page).to have_select("Organisation type",
                                options: ["-- Select an organisation type --",
                                          "Call centre",
                                          "Custody suite",
                                          "Law firm",
                                          "Law office"])

    select "Call centre", from: "Organisation type"

    check "Searchable"
    fill_in "Tel", with: "01632 960178"
    fill_in "Mobile", with: "07700 900407"
    fill_in "Address", with: "123 Fake Street"
    fill_in "Postcode", with: "POSTCODE"
    fill_in "Email", with: "imperial@example.com"

    click_button "Create Organisation"

    expect(page).to have_content "Organisation successfully created"
    expect(page).to have_content "Imperial College London"

    within "#imperial-college-london-row" do
      click_link "Show"
    end

    expect(page).to have_content "Name: Imperial College London"
    expect(page).to have_content "Slug: imperial-college-london"
    expect(page).to have_content "Tel: 01632 960178"
    expect(page).to have_content "Mobile: 07700 900407"
    expect(page).to have_content "Address: 123 Fake Street"
    expect(page).to have_content "Postcode: POSTCODE"
    expect(page).to have_content "Email: imperial@example.com"
  end

  specify "can create a sub-organisation" do
    visit organisations_path

    click_link "New Organisation"

    fill_in "Name", with: "Sub Organisation"
    fill_in "Slug", with: "sub-organisation"
    select "Law firm", from: "Organisation type"
    check "Searchable"
    fill_in "Tel", with: "01234 567890"
    fill_in "Mobile", with: "01234 567890"
    fill_in "Address", with: "123 Fake Street"
    fill_in "Postcode", with: "POSTCODE"
    fill_in "Email", with: "suborganisation@example.com"

    expect(page).to have_select("Parent organisation", options: ["---", organisation.name])

    select organisation.name, from: "Parent organisation"

    click_button "Create Organisation"

    expect(page).to have_content "Organisation successfully created"
    expect(page).to have_content "Sub Organisation"

    within "#sub-organisation-row" do
      click_link "Show"
    end

    expect(page).to have_content "Name: Sub Organisation"
    expect(page).to have_content "Parent Organisation: #{organisation.name}"
    expect(page).to have_link organisation.name, href: organisation_path(organisation)
  end

  specify "are shown errors if an organisation cannot be created" do
    visit organisations_path

    click_link "New Organisation"

    fill_in "Name", with: "LRUG"
    fill_in "Slug", with: "london-ruby-users-group"

    click_button "Create Organisation"

    expect(page).to have_content "You need to fix the errors on this page before continuing"
    expect(page).to have_content "Organisation type: can't be blank"
  end

  specify "can delete an organisation" do
    visit organisations_path

    click_link "Delete"

    expect(page).to have_content "Organisation successfully deleted"
    expect(page).to_not have_content organisation.name
  end

  specify "are shown errors if an organisation cannot be deleted" do
    visit organisations_path

    organisation_cannot_be_destroyed_for_some_reason organisation
    click_link "Delete"

    expect(page).to have_content "Organisation was not deleted"
    expect(page).to have_content organisation.name
  end

  specify "can edit relevant details for the organisation" do
    visit organisations_path

    click_link "Edit"
    fill_in "Name", with: "Ministry of Justice"
    fill_in "Slug", with: "ministry-of-justice"
    fill_in "Tel", with: "09011105010"
    fill_in "Address", with: "Somewhere"
    fill_in "Postcode", with: "555 PQ45"
    fill_in "Email", with: "moj@example.com"

    click_button "Update Organisation"

    expect(page).to have_content "Organisation successfully updated"
    expect(page).to have_content "Ministry of Justice"

    click_link "Show"

    expect(page).to have_content "Name: Ministry of Justice"
    expect(page).to have_content "Slug: ministry-of-justice"
    expect(page).to have_content "Tel: 09011105010"
    expect(page).to have_content "Address: Somewhere"
    expect(page).to have_content "Postcode: 555 PQ45"
    expect(page).to have_content "Email: moj@example.com"
  end

  specify "are shown errors if invalid details are entered" do
    visit organisations_path

    click_link "Edit"
    fill_in "Name", with: ""
    click_button "Update Organisation"

    expect(page).to have_content "You need to fix the errors on this page before continuing"
    expect(page).to have_content "Name: can't be blank"
  end

  specify "can view relevant details on a show page" do
    visit organisations_path

    click_link "Show"

    expect(page).to have_content "Name: #{organisation.name}"
    expect(page).to have_content "Slug: #{organisation.slug}"
    expect(page).to have_content "Organisation type: Law firm"
    expect(page).to have_content "Searchable: true"

    expect(page).to have_content "Members"
    organisation.profiles.each do |p|
      expect(page).to have_content p.name
    end
  end

  specify "can view members, and parent and child organisations and links on a show page" do
    parent = create :organisation
    org = create :organisation, parent_organisation: parent
    create_list :organisation, 3, parent_organisation: org

    visit organisation_path(org)

    expect(page).to have_content "Name: #{org.name}"
    expect(page).to have_content "Parent Organisation: #{parent.name}"
    expect(page).to have_link parent.name, href: organisation_path(parent)

    expect(page).to have_content "Suborganisations:"
    org.sub_organisations.each do |so|
      expect(page).to have_content so.name
      expect(page).to have_link so.name, href: organisation_path(so)
    end
  end

  specify "can add a new member from the show page" do
    visit organisations_path

    click_link "Show"
    click_link "New Member"

    select Profile.first.name
    click_button "Create Membership"

    expect(page).to have_content "Membership successfully created"
    expect(page).to have_content Profile.first.name
  end

  specify "are shown errors if a member cannot be added" do
    visit organisations_path

    click_link "Show"
    click_link "New Member"

    profile = Profile.first
    select profile.name
    profile.delete

    click_button "Create Membership"

    expect(page).to have_content "You need to fix the errors on this page before continuing."
    expect(page).to have_content "Member: can't be blank"
  end

  specify "can remove members from the show page" do
    organisation = Organisation.first
    visit organisation_path(organisation)

    first_member = organisation.profiles.first
    within"##{first_member.id}-row" do
      click_link "Remove Member"
    end

    expect(page).to have_content "Membership successfully deleted"
    expect(page).to_not have_content first_member.name
  end

  specify "are shown errors if a member cannot be removed" do
    organisation = Organisation.first
    visit organisation_path(organisation)

    first_member = organisation.profiles.first
    membership = first_member.membership_for organisation
    membership_cannot_be_destroyed_for_some_reason membership

    within"##{first_member.id}-row" do
      click_link "Remove Member"
    end

    expect(page).to have_content "Membership was not deleted"
  end
end

def organisation_cannot_be_destroyed_for_some_reason organisation
  expect(Organisation).to receive(:find).with(organisation.id.to_s) { organisation }
  expect(organisation).to receive(:destroy) { false }
end

def membership_cannot_be_destroyed_for_some_reason membership
  expect(Membership).to receive(:find).with(membership.id.to_s) { membership }
  expect(membership).to receive(:destroy) { false }
end
