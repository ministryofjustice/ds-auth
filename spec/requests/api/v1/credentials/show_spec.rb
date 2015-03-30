require "rails_helper"

RSpec.describe 'GET /api/v1/credentials/me ' do
  it "returns the user credentials" do
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
