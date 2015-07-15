require "rails_helper"

RSpec.shared_examples "removing a user" do
  let!(:other_user) { create :user }

  specify "can remove a User" do
    membership = create :membership, user: other_user, organisation: organisation

    visit organisation_path(organisation)
    within ".members #membership_#{membership.id}" do
      click_link "Delete membership"
    end

    expect(current_path).to eq(organisation_path(organisation))

    expect(page).to have_content("Membership successfully deleted")
    within ".members" do
      expect(page).not_to have_content(other_user.name)
    end
  end
end

RSpec.shared_examples "cannot remove a user" do
  let!(:other_user) { create :user }

  specify "cannot remove a User" do
    membership = create :membership, user: other_user, organisation: organisation

    visit organisation_path(organisation)
    within ".members #membership_#{membership.id}" do
      expect(page).not_to have_link("Delete membership")
    end
  end
end

RSpec.feature "Removing a Users from an Organisation" do
  let!(:user) { create :user }
  let!(:organisation) { create :organisation }

  before do
    login_as_user user.email, user.password
  end

  context "as a Webops User" do
    let!(:user) { create :user, is_webops: true }
    include_examples "removing a user"
  end

  context "as a User that is the Organisation admin" do
    before do
      create :membership, user: user, organisation: organisation, is_organisation_admin: true
    end
    include_examples "removing a user"
  end

  context "as a User in the same Organisation" do
    before do
      create :membership, user: user, organisation: organisation
    end
    include_examples "cannot remove a user"
  end
end
