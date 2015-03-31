require "rails_helper"

RSpec.describe 'GET /api/v1/credentials/me' do
  context 'with an invalid authentication token' do
    it 'returns a 401 response with an error message' do

      get "/api/v1/me", nil,
        {
          "Authorization": "Bearer foo",
          "Content-Type": "application/json"
        }

      expect(response.status).to eq(401)
      expect(response_json).to eq(
        {
          "errors" => ["Not authorized, please login"]
        }
      )
    end
  end

  context 'with a valid authentication token' do
    it "returns a 200 response with the user credentials" do
      application = create :application
      organisation = create :organisation
      government_application = create :government_application
      profile = create :profile, organisations: [organisation]
      role = create :role
      permissions = create_list(
        :permission,
        2,
        role: role,
        government_application: government_application,
        organisation: organisation
      )
      user = create :user, profile: profile, permissions: permissions
      token = create(
        :access_token,
        application: application,
        resource_owner_id: user.id,
        scopes: "public"
      )

      get "/api/v1/me", nil,
        {
        "Authorization": "Bearer #{token.token}",
        "Content-Type": "application/json"
        }

      expect(response.status).to eq(200)
      expect(response_json).to eq(
        {
          "user" => {
            "id" => user.id,
            "email" => user.email,
            "uid" => user.uid
          },
          "profile" => {
            "email" => user.profile.email,
            "name" => user.profile.name,
            "telephone" => user.profile.tel,
            "address" => {
              "full_address" => user.profile.address,
              "postcode" => user.profile.postcode,
            },
            "organisation_ids" => user.profile.organisations.map(&:id)
          },
          "roles" => user.roles.map(&:name)
        }
      )
    end
  end
end
