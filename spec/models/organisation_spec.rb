require 'rails_helper'

RSpec.describe Organisation do
  describe 'validations' do
    it { expect(subject).to validate_presence_of :name }
    it { expect(subject).to validate_presence_of :slug }
    it { expect(subject).to validate_presence_of :organisation_type }
  end

  describe 'associations' do
    specify { expect(subject).to have_many(:permissions) }
    specify { expect(subject).to have_many(:profiles).through(:memberships) }
  end

  describe "scopes" do
    describe ".by_name" do
      it "returns organisations in alphabetical order" do
        create :organisation, name: "First Organisation"
        create :organisation, name: "Second Organisation"
        create :organisation, name: "Third Organisation"

        expect(Organisation.by_name.pluck(:name)).to eq [
          "First Organisation",
          "Second Organisation",
          "Third Organisation"
        ]
      end
    end
  end
end
