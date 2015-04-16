require "rails_helper"

RSpec.describe "GET /api/v1/organisations" do
  it_behaves_like "a protected endpoint", "/api/v1/organisations"

  context "with a valid authentication token" do
    include_context "logged in API User"

    context "with no filtering parameters" do
      it "returns a 200 response with all organisations in name order" do
        tuckers  = create :organisation, name: "Tuckers", organisation_type: "law_firm"
        brighton = create :organisation, name: "Brighton", organisation_type: "custody_suite"
        tuckers_profile  = create :profile, user: user, organisations: [tuckers]
        brighton_profile = create :profile, organisations: [brighton]

        get "/api/v1/organisations", nil, api_request_headers

        expect(response.status).to eq(200)
        expect(response_json).to eq(
          "organisations" => [
            {
              "uid" => brighton.uid,
              "name" => "Brighton",
              "type" => brighton.organisation_type,
              "links" => {
                "profiles" => "/api/v1/profiles/uids[]=#{brighton_profile.uid}"
              }
            },
            {
              "uid" => tuckers.uid,
              "name" => "Tuckers",
              "type" => tuckers.organisation_type,
              "links" => {
                "profiles" => "/api/v1/profiles/uids[]=#{tuckers_profile.uid}"
              }
            }
          ]
        )
      end

      it "returns an empty 200 response if no organisations exist" do
        get "/api/v1/organisations", nil, api_request_headers

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
        tuckers_profile  = create :profile, user: user, organisations: [tuckers]

        get "/api/v1/organisations", { types: ["law_firm"] }, api_request_headers

        expect(response.status).to eq(200)
        expect(response_json).to eq(
          "organisations" => [
            {
              "uid" => tuckers.uid,
              "name" => "Tuckers",
              "type" => tuckers.organisation_type,
              "links" => {
                "profiles" => "/api/v1/profiles/uids[]=#{tuckers_profile.uid}"
              }
            }
          ]
        )
      end

      it "returns a 200 with many matching organisations if provided with many types, in name order" do
        tuckers  = create :organisation, name: "Tuckers", organisation_type: "law_firm"
        capita   = create :organisation, name: "Capita", organisation_type: "call_centre"
                   create :organisation, name: "Brighton", organisation_type: "custody_suite"
        tuckers_profile  = create :profile, user: user, organisations: [tuckers]
        capita_profile   = create :profile, organisations: [capita]

        get "/api/v1/organisations", { types: ["call_centre", "law_firm"] }, api_request_headers

        expect(response.status).to eq(200)
        expect(response_json).to eq(
          "organisations" => [
            {
              "uid" => capita.uid,
              "name" => "Capita",
              "type" => capita.organisation_type,
              "links" => {
                "profiles" => "/api/v1/profiles/uids[]=#{capita_profile.uid}"
              }
            },
            {
              "uid" => tuckers.uid,
              "name" => "Tuckers",
              "type" => tuckers.organisation_type,
              "links" => {
                "profiles" => "/api/v1/profiles/uids[]=#{tuckers_profile.uid}"
              }
            }
          ]
        )
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
  end
end
