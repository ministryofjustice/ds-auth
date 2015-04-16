require "rails_helper"

RSpec.describe "GET /api/v1/profiles/me" do
  it_behaves_like "a protected endpoint", "/api/v1/profiles/me"

  context "with a valid authentication token" do
    include_context "logged in API User"

    it "returns a 200 response with the user credentials" do
      organisation = create :organisation
      create :profile, user: user, organisations: [organisation]

      get "/api/v1/profiles/me", nil, api_request_headers

      expect(response.status).to eq(200)
      expect(response_json).to eq(
        {
          "user" => {
            "email" => user.email,
          },
          "profile" => {
            "email" => user.profile.email,
            "name" => user.profile.name,
            "telephone" => user.profile.tel,
            "mobile" => user.profile.mobile,
            "address" => {
              "full_address" => user.profile.address,
              "postcode" => user.profile.postcode,
            },
            "organisation_uids" => user.profile.organisations.map(&:uid),
            "uid" => user.profile.uid
          },
          "roles" => user.roles_for(application: application).map(&:name)
        }
      )
    end
  end
end
