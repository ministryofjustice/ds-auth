require 'rails_helper'

RSpec.describe Person do
  describe 'validations' do
    it { expect(subject).to validate_presence_of :name }
  end
end
