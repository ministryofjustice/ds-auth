require 'rails_helper'

RSpec.describe Permission do
  describe 'associations' do
    specify { expect(subject).to belong_to(:user) }
    specify { expect(subject).to belong_to(:role) }

    specify { expect(subject).to belong_to(:government_application) }
    specify { expect(subject).to belong_to(:organisation) }

  end
end