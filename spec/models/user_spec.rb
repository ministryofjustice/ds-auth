require 'rails_helper'

RSpec.describe User do
  let(:user){ create :user }
  let(:role) { Role.create(name: 'super-danger-admin') }

  describe 'associations' do
    specify { expect(subject).to have_one(:profile) }
    specify { expect(subject).to have_many(:permissions) }
    specify { expect(subject).to have_many(:roles).through(:permissions) }
  end
end
