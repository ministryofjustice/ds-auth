require "rails_helper"

RSpec.describe "GET /api/v1/profiles" do
  it_behaves_like "a protected endpoint", "/api/v1/profiles"

  context "with a valid authentication token" do
    include_context "logged in API User"

    context "with no filtering parameters" do
      it "returns a 200 response with all profiles in name order" do
        organisation    = create :organisation
        users_profile   = create :profile, name: "Eamonn Holmes", user: user, organisations: [organisation]
        another_profile = create :profile, name: "Barry Evans", organisations: [organisation]

        get "/api/v1/profiles", nil, api_request_headers

        expect(response.status).to eq(200)
        expect(response_json).to eq(
          "profiles" => [
            {
              "uid" => another_profile.uid,
              "name" => "Barry Evans",
              # "type" => another_profile.type,
              "links" => {
                "organisation" => "/api/v1/organisations/#{organisation.id}"
              }
            },
            {
              "uid" => users_profile.uid,
              "name" => "Eamonn Holmes",
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

    context "with a UID filter" do
      it "returns a 200 response with only matching profiles" do
        organisation     = create :organisation
        matching_profile = create :profile, user: user, organisations: [organisation]
                           create :profile, organisations: [organisation]

        get "/api/v1/profiles", { uids: [matching_profile.uid] }, api_request_headers

        expect(response.status).to eq(200)
        expect(response_json).to eq(
          "profiles" => [
            {
              "uid" => matching_profile.uid,
              "name" => matching_profile.name,
              # "type" => matching_profile.type,
              "links" => {
                "organisation" => "/api/v1/organisations/#{organisation.id}"
              }
            }
          ]
        )
      end

      it "returns a 200 with many matching profiles if provided with many UIDs, in name order" do
        organisation = create :organisation
        match_1      = create :profile, name: "Barry Scott", user: user, organisations: [organisation]
        match_2      = create :profile, name: "Barry Evans", organisations: [organisation]
                       create :profile, organisations: [organisation]

        get "/api/v1/profiles", { uids: [match_1.uid, match_2.uid] }, api_request_headers

        expect(response.status).to eq(200)
        expect(response_json).to eq(
          "profiles" => [
            {
              "uid" => match_2.uid,
              "name" => "Barry Evans",
              # "type" => match_2.type,
              "links" => {
                "organisation" => "/api/v1/organisations/#{organisation.id}"
              }
            },
            {
              "uid" => match_1.uid,
              "name" => "Barry Scott",
              # "type" => match_1.type,
              "links" => {
                "organisation" => "/api/v1/organisations/#{organisation.id}"
              }
            }
          ]
        )
      end

      it "returns an empty 200 response if no profiles match" do
        organisation = create :organisation
                       create :profile, organisations: [organisation]

        get "/api/v1/profiles", { uids: ["doesn't-exist"] }, api_request_headers

        expect(response.status).to eq(200)
        expect(response_json).to eq(
          "profiles" => []
        )
      end
    end
  end
end
