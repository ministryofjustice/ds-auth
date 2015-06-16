require "spec_helper"
require_relative "../../../lib/importers/solicitor_parser"

RSpec.describe Importers::SolicitorParser do
  describe "#import!" do
    it "creates Organisation and User models for each row" do
      allow(File).to receive(:open).with("test_file", "r").and_return(example_file)

      imported_data = Importers::SolicitorParser.new("test_file").import!

      expect(imported_data).to eq({
        "Lawyers Inc." => {
          slug: "lawyers-inc",
          organisation_type: "law_firm",
          users: [
            {
              name: "Mr. A Lawyer",
              telephone: "01234567890",
              email: "mr-a-lawyer@example.com",
              password: "password",
              password_confirmation: "password"
            },
            {
              name: "Mr. B Lawyer",
              telephone: "01234567890",
              email: "mr-b-lawyer@example.com",
              password: "password",
              password_confirmation: "password"
            }
          ]
        },
        "Solicitors LLC" => {
          slug: "solicitors-llc",
          organisation_type: "law_firm",
          users: [
            {
              name: "Mrs. A Solicitor",
              telephone: "09876543210",
              email: "mrs-a-solicitor@example.com",
              password: "password",
              password_confirmation: "password"
            }
          ]
        }
      })
    end
  end

  def example_file
    <<-FILE
Firm Name,Solicitor Name,Telephone Number,
Lawyers Inc.,Mr. A Lawyer,01234567890,
Lawyers Inc.,Mr. B Lawyer,01234567890,
Solicitors LLC,Mrs. A Solicitor,09876543210,
    FILE
  end
end
