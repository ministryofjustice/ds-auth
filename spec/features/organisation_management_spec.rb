require 'rails_helper'

RSpec.feature 'Users managing organisations' do
  let(:user) { create(:user) }
  let!(:organisation) { create(:organisation, :with_profiles_and_users, profile_count: 10) }

  before do
    login_as_user user.email
  end

  specify 'can view a list of all organisations' do
    visit organisations_path
    expect(page).to have_content "Organisations"
    expect(page).to have_content organisation.name
  end

  specify 'can create a new organisation' do
    visit organisations_path

    click_link "New Organisation"

    fill_in "Name", with: "Imperial College London"
    fill_in "Slug", with: "imperial-college-london"
    fill_in "Organisation type", with: "social"
    check "Searchable"

    click_button "Create Organisation"

    expect(page).to have_content "Organisation successfully created"
    expect(page).to have_content "Imperial College London"
  end

  specify 'are shown errors if an organisation cannot be created' do
    visit organisations_path

    click_link "New Organisation"

    fill_in "Name", with: "LRUG"
    fill_in "Slug", with: "london-ruby-users-group"

    click_button "Create Organisation"

    expect(page).to have_content "You need to fix the errors on this page before continuing"
    expect(page).to have_content "Organisation type: can't be blank"
  end

  specify 'can delete an organisation' do
    visit organisations_path

    click_link 'Delete'

    expect(page).to have_content 'Organisation successfully deleted'
    expect(page).to_not have_content organisation.name
  end

  specify 'are shown errors if an organisation cannot be deleted' do
    visit organisations_path

    organisation_cannot_be_destroyed_for_some_reason organisation
    click_link 'Delete'

    expect(page).to have_content 'Organisation was not deleted'
    expect(page).to have_content organisation.name
  end

  specify 'can edit relevant details for the organisation' do
    visit organisations_path

    click_link 'Edit'
    fill_in "Name", with: "North American Man Boy Love Association"
    fill_in "Slug", with: "north-american-man-boy-love-association"
    click_button 'Update Organisation'

    expect(page).to have_content "Organisation successfully updated"
    expect(page).to have_content "North American Man Boy Love Association"
  end

  specify 'are shown errors if invalid details are entered' do
    visit organisations_path

    click_link 'Edit'
    fill_in "Organisation type", with: ""
    click_button 'Update Organisation'

    expect(page).to have_content "You need to fix the errors on this page before continuing"
    expect(page).to have_content "Organisation type: can't be blank"
  end

  specify 'can view relevant details on a show page' do
    visit organisations_path

    click_link 'Show'

    expect(page).to have_content 'Name: NAMBLA'
    expect(page).to have_content 'Slug: north-american-marlon-brando-lookalikes'
    expect(page).to have_content 'Organisation type: social'
    expect(page).to have_content 'Searchable: true'

    expect(page).to have_content 'Members'
    expect(page).to have_content 'Barry Evans', count: 10
  end
end

def organisation_cannot_be_destroyed_for_some_reason organisation
  expect(Organisation).to receive(:find).with(organisation.id.to_s) { organisation }
  expect(organisation).to receive(:destroy) { false }
end
