require "rails_helper"

RSpec.describe "GET /api/v1/organisations/:uid" do
  it_behaves_like "a protected endpoint", "/api/v1/organisations/#{SecureRandom.uuid}"

  context "with a valid authentication token" do
    include_context "logged in API User"
    it_behaves_like "an endpoint that times out sessions", "/api/v1/organisations/#{SecureRandom.uuid}"

    it "returns a 200 response with the requested organisation, and profiles in name order" do
      organisation = create :organisation
      create :user, name: "Eamonn Holmes", organisations: [organisation]
      create :user, name: "Barry Evans", organisations: [organisation]

      get "/api/v1/organisations/#{organisation.uid}", nil, api_request_headers

      expect(response.status).to eq(200)
      expect(response_json).to eq(OrganisationSerializer.new(organisation).as_json.deep_stringify_keys)
    end

    it "returns a 404 response with an error with an invalid UID" do
      get "/api/v1/organisations/doesn't-exit", nil, api_request_headers

      expect(response.status).to eq(404)
      expect(response_json).to eq(
        "errors" => ["Resource not found"]
      )
    end
  end
end
