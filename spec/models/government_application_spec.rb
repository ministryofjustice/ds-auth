require 'rails_helper'

RSpec.describe GovernmentApplication do
  describe 'associations' do
    specify { expect(subject).to have_many(:permissions) }
    specify { expect(subject).to belong_to(:oauth_application) }
  end
end
