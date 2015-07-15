require "rails_helper"

RSpec.describe "GET /api/v1/me" do
  it_behaves_like "a protected endpoint", "/api/v1/me"

  context "with a valid authentication token" do
    include_context "logged in API User"
    it_behaves_like "an endpoint that times out sessions", "/api/v1/me"

    it "returns a 200 response with the user credentials" do

      # Note: application comes from the "logged in API User" context
      application_roles = ["admin"]
      application.update available_roles: application_roles

      organisation = create :organisation
      application.organisations << organisation

      membership = create :membership, user: user, organisation: organisation
      create :application_membership, application: application, membership: membership, roles: application.available_roles

      get "/api/v1/me", nil, api_request_headers

      expect(response.status).to eq(200)
      expect(response_json).to eq(
        {
          "user" => {
            "email" => user.email,
            "name" => user.name,
            "telephone" => user.telephone,
            "mobile" => user.mobile,
            "address" => {
              "full_address" => user.address,
              "postcode" => user.postcode,
            },
            "organisations" => [
                {
                    "uid" => organisation.uid,
                    "name" => organisation.name,
                    "roles" => application.available_roles
                }
            ],
            "uid" => user.uid
          }
        }
      )
    end
  end
end
