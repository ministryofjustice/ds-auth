require 'rails_helper'

RSpec.describe User do
  let(:user){ create :user }
  let(:role) { Role.create(name: 'super-danger-admin') }

  describe 'roles' do
    it 'associates a role' do
      user.roles << role
      expect(user.roles.first.name).to eq role.name
    end
  end
end
