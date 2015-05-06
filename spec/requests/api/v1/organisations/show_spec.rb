require "rails_helper"

RSpec.describe "GET /api/v1/organisations/:uid" do
  it_behaves_like "a protected endpoint", "/api/v1/organisations/#{SecureRandom.uuid}"

  context "with a valid authentication token" do
    include_context "logged in API User"

    it "returns a 200 response with the requested organisation, and profiles in name order" do
      organisation = create :organisation
      member_1 = create :profile, name: "Eamonn Holmes", user: user, organisations: [organisation]
      member_2 = create :profile, name: "Barry Evans", organisations: [organisation]

      get "/api/v1/organisations/#{organisation.uid}", nil, api_request_headers

      expect(response.status).to eq(200)
      expect(response_json).to eq(
        "organisation" => {
          "uid" => organisation.uid,
          "name" => organisation.name,
          "type" => organisation.organisation_type,
          "parent_organisation_uid" => nil,
          "sub_organisation_uids" => [],
          "links" => {
            "profiles" => "/api/v1/profiles?uids[]=#{member_2.uid}&uids[]=#{member_1.uid}",
            "parent_organisation" => nil,
            "sub_organisations" => nil
          }
        }
      )
    end

    context "with a parent organisation and sub organisations" do
      it "returns a 200 response with sub_organisations link" do
        parent_organisation = create :organisation
        organisation = create :organisation, parent_organisation: parent_organisation
        member_1 = create :profile, name: "Eamonn Holmes", user: user, organisations: [organisation]
        member_2 = create :profile, name: "Barry Evans", organisations: [organisation]

        sub_organisation1 = create :organisation, parent_organisation: organisation
        sub_organisation2 = create :organisation, parent_organisation: organisation

        get "/api/v1/organisations/#{organisation.uid}", nil, api_request_headers

        expect(response.status).to eq(200)
        expect(response_json).to eq(
          "organisation" => {
            "uid" => organisation.uid,
            "name" => organisation.name,
            "type" => organisation.organisation_type,
            "parent_organisation_uid" => parent_organisation.uid,
            "sub_organisation_uids" => [sub_organisation1.uid, sub_organisation2.uid],
            "links" => {
              "profiles" => "/api/v1/profiles?uids[]=#{member_2.uid}&uids[]=#{member_1.uid}",
              "parent_organisation" => "/api/v1/organisation/#{parent_organisation.uid}",
              "sub_organisations" => "/api/v1/organisations?uids[]=#{sub_organisation1.uid}&uids[]=#{sub_organisation2.uid}"
            }
          }
        )
      end
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
