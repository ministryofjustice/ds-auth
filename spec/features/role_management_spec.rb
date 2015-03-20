require 'rails_helper'

RSpec.feature 'Role management' do
  let(:user) { create(:user) }
  let!(:role) { create(:role) }

  before do
    login_as_user user.email
  end

  specify 'can view a list of all roles' do
    visit roles_path
    expect(page).to have_content "Roles"
    expect(page).to have_content role.name
  end
end
