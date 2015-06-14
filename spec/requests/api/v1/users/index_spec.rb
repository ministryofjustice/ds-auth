require "rails_helper"

RSpec.describe "GET /api/v1/users" do
  it_behaves_like "a protected endpoint", "/api/v1/users"

  context "with a valid authentication token" do
    include_context "logged in API User"

    context "with no filtering parameters" do
      it "returns a 200 response with all profiles in name order" do
        organisation    = create :organisation
        user.update name: "Eamon Holmes"
        another_user = create :user, name: "Barry Evans", organisations: [organisation]

        get "/api/v1/users", nil, api_request_headers

        expect(response.status).to eq(200)
        expect(response_json).to eq(UsersSerializer.new([another_user, user]).as_json.deep_stringify_keys)
      end
    end

    context "with a UID filter" do
      it "returns a 200 response with only matching users" do
        organisation     = create :organisation
        matching_user = create :user, organisations: [organisation]

        get "/api/v1/users", { uids: [matching_user.uid] }, api_request_headers

        expect(response.status).to eq(200)
        expect(response_json).to eq(UsersSerializer.new([matching_user]).as_json.deep_stringify_keys)
      end

      it "returns a 200 with many matching users if provided with many UIDs, in name order" do
        organisation = create :organisation
        match_1      = create :user, name: "Barry Scott", organisations: [organisation]
        match_2      = create :user, name: "Barry Evans", organisations: [organisation]
                       create :user, organisations: [organisation]

        get "/api/v1/users", { uids: [match_1.uid, match_2.uid] }, api_request_headers

        expect(response.status).to eq(200)
        expect(response_json).to eq(UsersSerializer.new([match_2, match_1]).as_json.deep_stringify_keys)
      end

      it "returns an empty 200 response if no users match" do
        organisation = create :organisation
                       create :user, organisations: [organisation]

        get "/api/v1/users", { uids: ["doesn't-exist"] }, api_request_headers

        expect(response.status).to eq(200)
        expect(response_json).to eq(UsersSerializer.new([]).as_json.deep_stringify_keys)
      end
    end
  end
end
