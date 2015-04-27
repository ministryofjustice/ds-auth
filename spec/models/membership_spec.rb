require "rails_helper"

RSpec.describe Membership do
  describe "associations" do
    specify { expect(subject).to belong_to(:profile) }
    specify { expect(subject).to belong_to(:organisation) }
  end

  describe "validations" do
    specify { expect(subject).to validate_presence_of(:profile) }
    specify { expect(subject).to validate_presence_of(:organisation) }

    specify do
      expect(subject).to validate_uniqueness_of(:profile_id).
        scoped_to(:organisation_id)
    end
  end
end
