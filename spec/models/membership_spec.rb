require "rails_helper"

RSpec.describe Membership, type: :model do
  describe "associations" do
    specify { expect(subject).to belong_to(:organisation) }
    specify { expect(subject).to belong_to(:user) }
  end

  describe "validations" do
    it { expect(subject).to validate_presence_of :user }
    it { expect(subject).to validate_presence_of :organisation }

    it "validates uniqueness_of user+organisation" do
      create :membership, user: create(:user), organisation: create(:organisation)
      expect(subject).to validate_uniqueness_of(:user_id).scoped_to(:organisation_id)
    end
  end

  describe "scopes" do
    describe "with_roles" do
      it "finds Memberships that match all the given roles" do
        create :membership, roles: ["foo", "bar"]
        membership2 = create :membership, roles: ["admin", "foo", "bar"]

        expect(Membership.with_roles("admin", "foo").to_a).to eq([membership2])
      end
    end

    describe "with_any_roles" do
      it "finds Memberships that match any the given roles" do
        membership1 = create :membership, roles: ["foo", "bar"]
        membership2 = create :membership, roles: ["admin", "foo", "bar"]
        create :membership, roles: ["admin", "bar"]

        expect(Membership.with_any_role("foo", "banana").to_a).to eq([membership1, membership2])
      end
    end
  end
end
