require 'rails_helper'

RSpec.describe Profile do

  describe 'validations' do
    [:name, :address, :postcode, :email, :tel, :mobile].each do |field|
      it { expect(subject).to validate_presence_of field }
    end
  end

  describe 'associations' do
    specify { expect(subject).to belong_to(:user) }
    specify { expect(subject).to have_many(:organisations).through(:memberships) }
  end
end
