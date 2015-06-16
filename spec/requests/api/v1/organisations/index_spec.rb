require "rails_helper"

RSpec.describe "GET /api/v1/organisations" do
  it_behaves_like "a protected endpoint", "/api/v1/organisations"

  context "with a valid authentication token" do
    include_context "logged in API User"

    context "with no filtering parameters" do
      it "returns a 200 response with all organisations in name order" do
        tuckers  = create :organisation, name: "Tuckers", organisation_type: "law_firm", supplier_number: "AABBCC12345678"
        tuckers_office  = create :organisation, name: "Tuckers Office", organisation_type: "law_office",
                            parent_organisation: tuckers, supplier_number: "AABBCC99999"
        brighton = create :organisation, name: "Brighton", organisation_type: "custody_suite"

        get "/api/v1/organisations", nil, api_request_headers

        expect(response.status).to eq(200)
        expect(response_json).to eq(OrganisationsSerializer.new([brighton, tuckers, tuckers_office]).as_json.deep_stringify_keys)
      end

      it "returns an empty 200 response if no organisations exist" do
        get "/api/v1/organisations", nil, api_request_headers

        expect(response.status).to eq(200)
        expect(response_json).to eq(
          "organisations" => []
        )
      end
    end

    context "with uids filter" do
      it "returns 200 response with matching organisations" do
        create :organisation, name: "Tuckers", organisation_type: "law_firm"
        brighton = create :organisation, name: "Brighton", organisation_type: "custody_suite"
        london   = create :organisation, name: "London", organisation_type: "custody_suite"

        get "/api/v1/organisations", { uids: [brighton.uid, london.uid] }, api_request_headers

        expect(response.status).to eq(200)
        expect(response_json).to eq(OrganisationsSerializer.new([brighton, london]).as_json.deep_stringify_keys)
      end

      it "returns an empty 200 response if not organisations match" do
        create :organisation, name: "Tuckers", organisation_type: "law_firm"

        get "/api/v1/organisations", { uids: ["a-random-guid"] }, api_request_headers

        expect(response.status).to eq(200)
        expect(response_json).to eq(
          "organisations" => []
        )
      end
    end

    context "with a type filter" do
      it "returns a 200 response with only matching organisations" do
        tuckers  = create :organisation, name: "Tuckers", organisation_type: "law_firm"
                   create :organisation, name: "Brighton", organisation_type: "custody_suite"

        get "/api/v1/organisations", { types: ["law_firm"] }, api_request_headers

        expect(response.status).to eq(200)
        expect(response_json).to eq(OrganisationsSerializer.new([tuckers]).as_json.deep_stringify_keys)
      end

      it "returns a 200 with many matching organisations if provided with many types, in name order" do
        tuckers  = create :organisation, name: "Tuckers", organisation_type: "law_firm"
        capita   = create :organisation, name: "Capita", organisation_type: "drs_call_center"
                   create :organisation, name: "Brighton", organisation_type: "custody_suite"

        get "/api/v1/organisations", { types: ["drs_call_center", "law_firm"] }, api_request_headers

        expect(response.status).to eq(200)
        expect(response_json).to eq(OrganisationsSerializer.new([capita, tuckers]).as_json.deep_stringify_keys)
      end

      it "returns an empty 200 response if no organisations match" do
        create :organisation, organisation_type: "custody_suite"

        get "/api/v1/organisations", { types: ["doesn't-exist"] }, api_request_headers

        expect(response.status).to eq(200)
        expect(response_json).to eq(
          "organisations" => []
        )
      end
    end

    context "with uids and type filters" do
      it "returns 200 response with matching organisations" do
        tuckers = create :organisation, name: "Tuckers", organisation_type: "law_firm"
        london   = create :organisation, name: "London", organisation_type: "custody_suite"

        get "/api/v1/organisations", { uids: [tuckers.uid, london.uid], types: [london.organisation_type] }, api_request_headers

        expect(response.status).to eq(200)
        expect(response_json).to eq(OrganisationsSerializer.new([london]).as_json.deep_stringify_keys)
      end

      it "returns an empty 200 response if not organisations match" do
        create :organisation, name: "Tuckers", organisation_type: "law_firm"

        get "/api/v1/organisations", { uids: ["a-random-guid"], types: ["law_firm"] }, api_request_headers

        expect(response.status).to eq(200)
        expect(response_json).to eq(
          "organisations" => []
        )
      end
    end
  end
end
