require "rails_helper"

RSpec.describe Organisation do
  describe "validations" do
    it { expect(subject).to validate_presence_of :name }
    it { expect(subject).to validate_presence_of :slug }
    it { expect(subject).to validate_presence_of :organisation_type }
    it { expect(subject).to allow_value("call_centre").for(:organisation_type) }
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
    specify { expect(subject).to have_many(:permissions) }
    specify { expect(subject).to have_many(:profiles).through(:memberships) }

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
end
