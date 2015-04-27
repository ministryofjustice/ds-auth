require "rails_helper"

RSpec.describe Permission do
  describe "associations" do
    specify { expect(subject).to belong_to(:user) }
    specify { expect(subject).to belong_to(:role) }

    specify { expect(subject).to belong_to(:application) }
    specify { expect(subject).to belong_to(:organisation) }
  end

  describe "validations" do
    specify { expect(subject).to validate_presence_of(:user) }
    specify { expect(subject).to validate_presence_of(:application) }
    specify { expect(subject).to validate_presence_of(:role) }
    specify { expect(subject).to validate_presence_of(:role) }

    specify do
      expect(subject).to validate_uniqueness_of(:user_id).
        scoped_to(:role_id, :application_id, :organisation_id)
    end
  end

  describe ".for_application" do
    let!(:application) { create :doorkeeper_application }
    let!(:application2) { create :doorkeeper_application }

    let!(:permission1) { create :permission, application: application }
    let!(:permission2) { create :permission, application: application2 }

    it "returns an ActiveRecord::Relation" do
      expect(Permission.for_application(application).class.ancestors).to include(ActiveRecord::Relation)
    end

    it "returns permissions only for the given application" do
      expect(Permission.for_application(application)).to eq([permission1])
    end
  end
end
