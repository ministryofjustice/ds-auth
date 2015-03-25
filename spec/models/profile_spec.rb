require 'rails_helper'

RSpec.describe Profile do
  describe 'validations' do
    it { expect(subject).to validate_presence_of :name }
  end

  describe 'associations' do
    specify { expect(subject).to belong_to(:user) }
    specify { expect(subject).to have_many(:organisations).through(:memberships) }
  end
end
