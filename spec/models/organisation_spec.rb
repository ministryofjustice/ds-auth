require "rails_helper"

RSpec.describe Organisation do
  describe "validations" do
    it { expect(subject).to validate_presence_of :name }
    it { expect(subject).to validate_presence_of :slug }
    it { expect(subject).to validate_presence_of :organisation_type }
    it { expect(subject).to validate_inclusion_of(:organisation_type).in_array(Organisation::ORGANISATION_TYPES) }
    it { expect(subject).to_not allow_value("doesnt_exist").for(:organisation_type) }

    context "circular references" do
      let!(:organisation)       { create :organisation }
      let!(:child_organisation) { create :organisation,
                                         parent_organisation: organisation }

      it "invalid if two organisations reference each other" do
        organisation.parent_organisation = child_organisation
        expect(organisation).to be_invalid
        expect(child_organisation).to be_invalid
      end

      it "valid if 3 organisations are hierarchical" do
        grandchild_organisation = create :organisation,
                                         parent_organisation: child_organisation
        expect(organisation).to be_valid
        expect(child_organisation).to be_valid
        expect(grandchild_organisation).to be_valid
      end

      it "invalid if 3 organisations are circular" do
        grandchild_organisation = create :organisation,
                                         parent_organisation: child_organisation
        organisation.parent_organisation = grandchild_organisation
        expect(organisation).to be_invalid
        expect(child_organisation).to be_invalid
        expect(grandchild_organisation).to be_invalid
      end
    end
  end

  describe "associations" do
    specify { expect(subject).to have_many(:memberships) }
    specify { expect(subject).to have_many(:users).through(:memberships) }

    specify { expect(subject).to have_many(:sub_organisations).
              class_name("Organisation").
              with_foreign_key("parent_organisation_id") }
    specify { expect(subject).to belong_to(:parent_organisation).
              class_name("Organisation") }
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

  describe ".create_from_attributes" do
    context "with fully valid data" do
      let (:attributes) {
        {
          "Test Firm" => {
            slug: "test-firm",
            organisation_type: "law_firm",
            users: [
              {
                name: "Mr Test User",
                telephone: "01234567890",
                email: "mr-test-user@example.com",
                password: "password",
                password_confirmation: "password"
              }
            ]
          }
        }
      }

      before :each do
        Organisation.create_from_attributes(attributes)
      end

      it "creates the Organisation" do
        expect(Organisation.count).to eq 1
        expect(Organisation.last.slug).to eq "test-firm"
      end

      it "creates the User" do
        expect(User.count).to eq 1
        expect(User.last.email).to eq "mr-test-user@example.com"
      end

      it "creates the Membership with roles" do
        expect(Organisation.last.users.count).to eq 1
        expect(Membership.last.roles).not_to be_empty
      end
    end

    context "with invalid organisation attributes" do
      let(:attributes)  {
        {
          "Test Firm" => {
            slug: "",
            organisation_type: "law_firm",
            users: [
              {
                name: "Mr Test User",
                telephone: "01234567890",
                email: "mr-test-user@example.com",
                password: "password",
                password_confirmation: "password"
              }
            ]
          }
        }
      }

      before :each do
        Organisation.create_from_attributes(attributes)
      end

      it "does not create the Organisation" do
        expect(Organisation.count).to eq 0
      end

      it "does not create the User" do
        expect(User.count).to eq 0
      end

      it "does not create any Memberships" do
        expect(Membership.count).to eq 0
      end
    end

    context "with invalid user attributes" do
      let(:attributes)  {
        {
          "Test Firm" => {
            slug: "test-firm",
            organisation_type: "law_firm",
            users: [
              {
                name: "Mr Test User",
                telephone: "01234567890",
                email: "mr-test-user@example.com",
                password: "",
                password_confirmation: ""
              }
            ]
          }
        }
      }

      before :each do
        Organisation.create_from_attributes(attributes)
      end

      it "does not create the Organisation" do
        expect(Organisation.count).to eq 0
      end

      it "does not create the User" do
        expect(User.count).to eq 0
      end

      it "does not create any Memberships" do
        expect(Membership.count).to eq 0
      end
    end

    context "with only partially invalid data" do
      let(:attributes) {
        {
          "Test Firm" => {
            slug: "test-firm",
            organisation_type: "law_firm",
            users: []
          },
          "Invalid Firm" => {
            slug: "",
            organisation_type: "",
            users: []
          }
        }
      }

      it "does not create any of the Organisations" do
        Organisation.create_from_attributes(attributes)

        expect(Organisation.count).to eq 0
      end
    end
  end
end
