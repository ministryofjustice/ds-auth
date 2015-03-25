require 'rails_helper'

RSpec.describe Organisation do
  describe 'validations' do
    it { expect(subject).to validate_presence_of :name }
    it { expect(subject).to validate_presence_of :slug }
    it { expect(subject).to validate_presence_of :organisation_type }
  end

  describe 'associations' do
    specify { expect(subject).to have_many(:permissions) }
    specify { expect(subject).to have_many(:profiles).through(:organisation_memberships) }
  end
end
