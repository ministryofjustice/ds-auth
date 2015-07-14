require "rails_helper"

RSpec.describe "GET /oauth/authorize" do
  include Warden::Test::Helpers

  let!(:resource_owner) { create :user }
  let(:organisation) { create :organisation }

  before do
    Warden.test_mode!
    login_as(resource_owner, scope: :user)
  end

  def authorize_url
    oauth_authorization_url(
      client_id: doorkeeper_app.uid,
      redirect_uri: doorkeeper_app.redirect_uri,
      response_type: "code",
      state: "TEST_VALUE"
    )
  end

  context "when the application does not handle its own authorization" do
    let!(:doorkeeper_app) {
      create :doorkeeper_application,
      redirect_uri: "https://localhost:34343/auth/callback"
    }

    context "the user has a role for the application" do
      it "redirects to the apps auth callback uri" do
        create :membership, user: resource_owner, organisation: organisation, permissions: { roles: ["admin"] }
        allow_any_instance_of(Doorkeeper::Application).to receive(:available_role_names).and_return ["admin"]

        get authorize_url

        # all we want to check is the redirect goes to the redirect_uri
        # not whether the code and state params are correct
        response_redirect_uri = URI.parse response.headers["Location"]
        response_redirect_uri.query = nil

        expect(response_redirect_uri.to_s).to eq(doorkeeper_app.redirect_uri)
      end
    end

    context "the user has no role for the application" do
      it "redirects to the apps auth failure uri" do
        get authorize_url
        expect(response).to redirect_to("https://localhost:34343/auth/failure?message=unauthorized")
      end
    end
  end

  context "when the application handles it own authorization" do
    let!(:doorkeeper_app) {
      create :doorkeeper_application,
      redirect_uri: "https://localhost:34343/auth/callback",
      handles_own_authorization: true
    }

    context "the user has a role for the application" do
      it "redirects to the apps auth callback uri" do
        create :membership, user: resource_owner, organisation: organisation, permissions: { roles: ["admin"] }
        allow_any_instance_of(Doorkeeper::Application).to receive(:available_role_names).and_return ["admin"]

        get authorize_url

        response_redirect_uri = URI.parse response.headers["Location"]
        response_redirect_uri.query = nil

        expect(response_redirect_uri.to_s).to eq(doorkeeper_app.redirect_uri)
      end
    end

    context "the user has no role for the application" do
      it "redirects to the apps auth callback uri" do
        get authorize_url

        response_redirect_uri = URI.parse response.headers["Location"]
        response_redirect_uri.query = nil

        expect(response_redirect_uri.to_s).to eq(doorkeeper_app.redirect_uri)
      end
    end
  end
end
