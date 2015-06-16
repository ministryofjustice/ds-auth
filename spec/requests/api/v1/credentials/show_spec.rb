require "rails_helper"

RSpec.describe "GET /api/v1/profiles/me" do
  it_behaves_like "a protected endpoint", "/api/v1/profiles/me"

  context "with a valid authentication token" do
    include_context "logged in API User"

    it "returns a 200 response with the user credentials" do
      organisation = create :organisation
      create :membership, user: user, organisation: organisation, permissions: { roles: ["admin"] }

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
            "organisation_uids" => user.organisations.map(&:uid),
            "uid" => user.uid
          },
          "roles" => ["admin"]
        }
      )
    end
  end
end
