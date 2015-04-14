require 'rails_helper'

RSpec.describe Profile do
  describe 'validations' do
    subject { create :profile }

    [:name, :address, :postcode, :email, :tel, :mobile].each do |field|
      it { expect(subject).to validate_presence_of field }
    end

    specify { expect(subject).to validate_uniqueness_of(:user_id).allow_nil }
  end

  describe 'associations' do
    specify { expect(subject).to belong_to(:user) }
    specify { expect(subject).to have_many(:organisations).through(:memberships) }
  end
end
