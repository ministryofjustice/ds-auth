require "rails_helper"

RSpec.describe "GET /api/v1/users/search?q=:term" do
  it_behaves_like "a protected endpoint", "/api/v1/users/search?q=searchterm"

  context "with a valid authentication token" do
    include_context "logged in API User"

    it "returns a 200 response with users whose name matches the search term, in ID order" do
      matching_user_1 = create :user, name: "Bob Smith", email: "bob.smith@b.com", id: 123
      matching_user_2 = create :user, name: "BOB SMITH", email: "bob.smith@a.com", id: 122
                        create :user, name: "Shirley Smith"

      get "/api/v1/users/search", { q: "bob smith" }, api_request_headers

      expect(response.status).to eq(200)
      expect(response_json).to eq (UsersSerializer.new([matching_user_2, matching_user_1]).as_json.deep_stringify_keys)
    end

    it "returns an empty 200 response if the q param is omitted" do
      get "/api/v1/users/search", nil, api_request_headers

      expect(response.status).to eq(200)
      expect(response_json).to eq (UsersSerializer.new([]).as_json.deep_stringify_keys)
    end

    it "returns an empty 200 response if no users match the search term" do
      create :user, name: "Bob Smith"
      create :user, name: "Shirley Smith"

      get "/api/v1/users/search", { q: "john doe" }, api_request_headers

      expect(response.status).to eq(200)
      expect(response_json).to eq (UsersSerializer.new([]).as_json.deep_stringify_keys)
    end
  end
end
