require "rails_helper"

RSpec.feature "Listing Users" do
  let!(:user) { create :user }

  before do
    login_as_user user.email, user.password
  end

  context "user is webops" do
    let!(:user) { create :user, is_webops: true }

    specify "shows all Users" do
      user_1 = create :user, organisations: [create(:organisation)]
      user_2 = create :user

      visit users_path

      expect(current_path).to eq(users_path)
      expect(page).to have_content(user_1.name)
      expect(page).to have_content(user_2.name)
    end
  end

  context "user is not webops" do
    specify "only shows the Users from the Organisations the current user is a member of" do
      organisation = create :organisation
      user_1 = create :user, organisations: [organisation]
      user_2 = create :user
      create :membership, user: user, organisation: organisation

      visit users_path

      expect(current_path).to eq(users_path)
      expect(page).to have_content(user_1.name)
      expect(page).not_to have_content(user_2.name)
    end

    specify "shows no other users when the current user is a member of no Organisations" do
      user_1 = create :user
      user_2 = create :user

      visit users_path

      expect(current_path).to eq(users_path)
      expect(page).not_to have_content(user_1.name)
      expect(page).not_to have_content(user_2.name)
    end
  end
end


