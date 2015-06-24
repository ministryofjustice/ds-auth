require "rails_helper"

RSpec.feature "Listing Organisations" do
  let!(:user) { create :user }

  before do
    login_as_user user.email, user.password
  end

  specify "only shows the Organisations the User is a member of" do
    organisation_1 = create :organisation
    organisation_2 = create :organisation
    create :membership, user: user, organisation: organisation_1

    visit organisations_path

    expect(current_path).to eq(organisations_path)
    expect(page).to have_content(organisation_1.name)
    expect(page).not_to have_content(organisation_2.name)
  end

end


