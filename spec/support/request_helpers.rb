RSpec.shared_context "logged in API User" do
  let!(:user)        { create :user,
                       :logged_in_to_applications,
                       number_of_applications: 1 }
  let(:application)  { Doorkeeper::Application.first }
  let!(:token)       { Doorkeeper::AccessToken.
                       where(application_id: application,
                             resource_owner_id: user.id).first }

  def api_request_headers
    {
      "Authorization": "Bearer #{token.token}",
      "Content-Type": "application/json"
    }
  end
end

RSpec.shared_examples "a protected endpoint" do |url|
  it "returns a 401 response with an error message for unauthenticated requests" do

    get url, nil,
      {
        "Authorization": "Bearer foo",
        "Content-Type": "application/json"
      }

    expect(response.status).to eq(401)
    expect(response_json).to eq(
      {
        "errors" => ["The access token is invalid"]
      }
    )
  end
end

RSpec.shared_examples "an endpoint that times out sessions" do |url|
  it "returns a 401 response when the access_token has expired" do
    expect(token).not_to be_nil, "must supply a token in the spec scope"

    Timecop.travel((Settings.doorkeeper.session_timeout + 2).minutes.from_now) do

      get url, nil, api_request_headers

      expect(response.status).to eq(401)
      expect(response_json).to eq(
        {
          "errors" => ["The access token expired"]
        }
      )
    end
  end
end
