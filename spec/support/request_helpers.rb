RSpec.shared_context "logged in API User" do
  let!(:user)        { create :user,
                       :logged_in_to_applications,
                       number_of_applications: 1 }
  let!(:application) { user.permissions.first.application }
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
  it 'returns a 401 response with an error message for unauthenticated requests' do

    get url, nil,
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
