require 'rails_helper'

RSpec.describe Organisation do
  describe 'validations' do
    it { expect(subject).to validate_presence_of :name }
    it { expect(subject).to validate_presence_of :slug }
    it { expect(subject).to validate_presence_of :organisation_type }
    it { expect(subject).to validate_presence_of :searchable }
  end
end
