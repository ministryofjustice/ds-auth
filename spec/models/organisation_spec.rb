require "rails_helper"

RSpec.describe Organisation do
  describe "validations" do
    it { expect(subject).to validate_presence_of :name }
    it { expect(subject).to validate_presence_of :slug }

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

  describe "an organisation with a name" do
    subject{ build(:organisation, name: "ACME organisation PLC", slug: slug) }

    describe "being saved from new" do
      context "with a blank slug" do
        let(:slug){ nil }

        it "auto-populates the slug" do
          subject.save!
          expect( subject.slug ).not_to be_blank
        end
      end

      context "with a given slug" do
        let(:slug){ "some-given-slug" }

        it "does not change the given slug" do
          subject.save!
          expect( subject.slug ).to eq("some-given-slug")
        end
      end

      context "with a slug that already exists" do
        let!(:existing_org){ create :organisation, slug: "duplicate-slug" }

        context "saving an organisation with the same slug" do
          let(:slug){ "duplicate-slug" }

          it "does not fail" do
            expect{ subject.save! }.not_to raise_error
          end

          it "appends a suffix to make the slug unique" do
            subject.save!
            expect( subject.slug ).to start_with("duplicate-slug-")
          end
        end
      end
    end
  end
end
