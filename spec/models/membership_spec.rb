require 'rails_helper'

RSpec.describe Membership do
  describe 'associations' do
    specify { expect(subject).to belong_to(:profile) }
    specify { expect(subject).to belong_to(:organisation) }
  end

  describe 'validations' do
    specify { expect(subject).to validate_presence_of(:profile) }
    specify { expect(subject).to validate_presence_of(:organisation) }
  end
end
