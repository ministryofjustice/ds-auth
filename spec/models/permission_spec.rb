require 'rails_helper'

RSpec.describe Permission do
  describe 'associations' do
    specify { expect(subject).to belong_to(:user) }
    specify { expect(subject).to belong_to(:role) }

    specify { expect(subject).to belong_to(:application) }
    specify { expect(subject).to belong_to(:organisation) }
  end

  describe 'validations' do
    specify { expect(subject).to validate_presence_of(:user) }
    specify { expect(subject).to validate_presence_of(:application) }
    specify { expect(subject).to validate_presence_of(:role) }
    specify { expect(subject).to validate_presence_of(:role) }

    specify do
      expect(subject).to validate_uniqueness_of(:user_id).
        scoped_to(:role_id, :application_id, :organisation_id)
    end
  end
end
