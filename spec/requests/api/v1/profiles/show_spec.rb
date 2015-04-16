require "rails_helper"

RSpec.describe "GET /api/v1/profiles/:uid" do
  it_behaves_like "a protected endpoint", "/api/v1/profiles/#{SecureRandom.uuid}"

  context "with a valid authentication token" do
    include_context "logged in API User"

    it "returns a 200 response with the requested profile" do
      organisation = create :organisation
      profile = create :profile, user: user, organisations: [organisation]

      get "/api/v1/profiles/#{profile.uid}", nil, api_request_headers

      expect(response.status).to eq(200)
      expect(response_json).to eq(
        "profile" => {
          "uid" => profile.uid,
          "name" => profile.name,
          # "type" => profile.type,
          "links" => {
            "organisation" => "/api/v1/organisations/#{organisation.id}"
          }
        }
      )
    end

    it "returns a 404 response with an error with an invalid UID" do
      get "/api/v1/profiles/doesn't-exit", nil, api_request_headers

      expect(response.status).to eq(404)
      expect(response_json).to eq(
        "errors" => ["Resource not found"]
      )
    end
  end
end
