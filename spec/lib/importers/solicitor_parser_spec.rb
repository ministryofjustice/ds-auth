require "spec_helper"
require_relative "../../../lib/importers/solicitor_parser"

RSpec.describe Importers::SolicitorParser do
  describe "#import!" do
    it "creates Organisation and User models for each row, without duplicates" do
      imported_data = Importers::SolicitorParser.new("spec/support/fixtures/test.csv").import!

      expect(imported_data).to eq({
        "Law Firm Plc." => {
          slug: "law-firm-plc",
          organisation_type: "law_firm",
          users: {
            "a-lawyer@law-firm.com" => {
              name: "Mr A Lawyer",
              telephone: "01234 012345"
            },
          }
        },
        "Solicitors Inc." => {
          slug: "solicitors-inc",
          organisation_type: "law_firm",
          users: {
            "a-solicitor@solicitors-inc.com" => {
              name: "Mr A Solicitor",
              telephone: "01234 567890"
            }
          }
        }
      })
    end
  end
end
