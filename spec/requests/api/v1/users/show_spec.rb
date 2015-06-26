require "rails_helper"

RSpec.describe "GET /api/v1/users/:uid" do
  it_behaves_like "a protected endpoint", "/api/v1/users/#{SecureRandom.uuid}"

  context "with a valid authentication token" do
    include_context "logged in API User"
    it_behaves_like "an endpoint that times out sessions", "/api/v1/users/#{SecureRandom.uuid}"

    it "returns a 200 response with the requested user" do
      organisation = create :organisation
      user = create :user, organisations: [organisation]

      get "/api/v1/users/#{user.uid}", nil, api_request_headers

      expect(response.status).to eq(200)
      expect(response_json).to eq(UserSerializer.new(user).as_json.deep_stringify_keys)
    end

    it "returns a 404 response with an error with an invalid UID" do
      get "/api/v1/users/doesn't-exit", nil, api_request_headers

      expect(response.status).to eq(404)
      expect(response_json).to eq(
        "errors" => ["Resource not found"]
      )
    end
  end
end
