require 'rails_helper'

RSpec.describe Role do
  describe 'associations' do
    specify { expect(subject).to have_many(:permissions) }
    specify { expect(subject).to have_many(:users).through(:permissions) }
  end
end
