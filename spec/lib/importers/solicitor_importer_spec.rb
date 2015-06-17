require "rails_helper"
require_relative "../../../lib/importers/solicitor_importer"

RSpec.describe Importers::SolicitorImporter do
  describe ".create_from_attributes" do
    context "with fully valid data" do
      let (:attributes) {
        {
          "Test Firm" => {
            slug: "test-firm",
            organisation_type: "law_firm",
            users: {
              "mr-test-user@example.com" => {
                name: "Mr Test User",
                telephone: "01234567890"
              }
            }
          }
        }
      }

      before :each do
        Importers::SolicitorImporter.create_from_attributes(attributes)
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
        expect(Membership.last.roles).to include("solicitor_admin")
      end
    end

    context "with invalid organisation attributes" do
      let(:attributes)  {
        {
          "Test Firm" => {
            slug: "",
            organisation_type: "law_firm",
            users: {
              "mr-test-user@example.com" => {
                name: "Mr Test User",
                telephone: "01234567890"
              }
            }
          }
        }
      }

      before :each do
        Importers::SolicitorImporter.create_from_attributes(attributes)
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
            users: {
              "mr-test-user@example.com" => {
                # name: nil
              }
            }
          }
        }
      }

      before :each do
        Importers::SolicitorImporter.create_from_attributes(attributes)
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
            users: {}
          },
          "Invalid Firm" => {
            slug: "",
            organisation_type: "",
            users: {}
          }
        }
      }

      it "does not create any of the Organisations" do
        Importers::SolicitorImporter.create_from_attributes(attributes)

        expect(Organisation.count).to eq 0
      end
    end
  end
end
