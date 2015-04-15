require "rails_helper"

RSpec.describe "GET /api/v1/profiles" do
  it_behaves_like "a protected endpoint", "/api/v1/profiles"

  context "with a valid authentication token" do
    include_context "logged in API User"

    context "with no filtering parameters" do
      it "returns a 200 response with all profiles" do
        organisation    = create :organisation
        users_profile   = create :profile, name: "Eamonn Holmes", user: user, organisations: [organisation]
        another_profile = create :profile, name: "Barry Evans", organisations: [organisation]

        get "/api/v1/profiles", nil, api_request_headers

        expect(response.status).to eq(200)
        expect(response_json).to eq(
          "profiles" => [
            {
              "uid" => another_profile.uid,
              "name" => another_profile.name,
              # "type" => another_profile.type,
              "links" => {
                "organisation" => "/api/v1/organisations/#{organisation.id}"
              }
            },
            {
              "uid" => users_profile.uid,
              "name" => users_profile.name,
              # "type" => users_profile.type,
              "links" => {
                "organisation" => "/api/v1/organisations/#{organisation.id}"
              }
            }
          ]
        )
      end

      it "returns an empty 200 response if no profiles exist" do
        get "/api/v1/profiles", nil, api_request_headers

        expect(response.status).to eq(200)
        expect(response_json).to eq(
          "profiles" => []
        )
      end
    end
  end
end
