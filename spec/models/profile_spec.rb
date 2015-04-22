require "rails_helper"

RSpec.describe Profile do
  describe "validations" do
    subject { create :profile }

    [:name, :address, :postcode, :email, :tel, :mobile].each do |field|
      it { expect(subject).to validate_presence_of field }
    end

    specify { expect(subject).to validate_uniqueness_of(:user_id).allow_nil }
    specify { expect(subject).to validate_uniqueness_of(:email) }

    specify { expect(subject).to allow_value("email@example.com").for(:email) }
    specify { expect(subject).to_not allow_value("email@example").for(:email) }
    specify { expect(subject).to_not allow_value("email-example.com").for(:email) }
    specify { expect(subject).to_not allow_value("hello***@example.com").for(:email) }
  end

  describe "associations" do
    specify { expect(subject).to belong_to(:user) }
    specify { expect(subject).to have_many(:organisations).through(:memberships) }
  end

  describe "scopes" do
    describe ".by_name" do
      it "returns profiles in alphabetical order" do
        create :profile, name: "First Profile"
        create :profile, name: "Second Profile"
        create :profile, name: "Third Profile"

        expect(Profile.by_name.pluck(:name)).to eq [
          "First Profile",
          "Second Profile",
          "Third Profile"
        ]
      end
    end
  end
end
