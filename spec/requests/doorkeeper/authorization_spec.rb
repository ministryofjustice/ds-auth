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
    context "the user has a role for the application" do
      let!(:doorkeeper_app) {
        create :doorkeeper_application,
        redirect_uri: "https://localhost:34343/auth/callback",
        available_roles: ["viewer"]
      }

      it "redirects to the apps auth callback uri" do
        doorkeeper_app.organisations << organisation
        doorkeeper_app.save!
        membership = create :membership, user: resource_owner, organisation: organisation
        create :application_membership, application: doorkeeper_app, membership: membership, roles: doorkeeper_app.available_roles

        get authorize_url
        sleep 2
        # puts "URI:"
        # puts response.headers["Location"]
        # all we want to check is the redirect goes to the redirect_uri
        # not whether the code and state params are correct
        response_redirect_uri = URI.parse response.headers["Location"]
        response_redirect_uri.query = nil

        expect(response_redirect_uri.to_s).to eq(doorkeeper_app.redirect_uri)
      end
    end

    context "the user has no role for the application" do
      context "the application has not provided a failure URI" do
        let!(:doorkeeper_app) {
          create :doorkeeper_application,
          redirect_uri: "https://redirect.example:34343/auth/callback"
        }

        it "creates a failure URI from the redirect hostname" do
          get authorize_url
          expect(response).to redirect_to("https://redirect.example:34343/auth/failure?message=unauthorized")
        end
      end

      context "the application has provided a failure URIs" do
        let!(:doorkeeper_app) {
          create :doorkeeper_application,
          redirect_uri: "https://redirect.example:34343/auth/callback",
          failure_uri: "https://redirect.example:34343/failure\r\nhttps://not-redirect.example:34343/failure"
        }

        it "selects the correct failure URI based on the redirect hostname" do
          get authorize_url
          expect(response).to redirect_to("https://redirect.example:34343/failure")
        end
      end
    end
  end

  context "when the application handles it own authorization" do
    let!(:doorkeeper_app) {
      create :doorkeeper_application,
      redirect_uri: "https://localhost:34343/auth/callback",
      handles_own_authorization: true
    }
    let!(:membership) { create :membership, user: resource_owner, organisation: organisation }

    before do
      doorkeeper_app.organisations << organisation
      doorkeeper_app.save!
    end

    context "the user has access to the application" do
      it "redirects to the apps auth callback uri" do
        create :application_membership, application: doorkeeper_app, membership: membership, can_login: true

        get authorize_url
        sleep 2

        response_redirect_uri = URI.parse response.headers["Location"]
        response_redirect_uri.query = nil

        expect(response_redirect_uri.to_s).to eq(doorkeeper_app.redirect_uri)
      end
    end

    context "the user does not have access to the application" do
      it "redirects to the failure uri" do
        create :application_membership, application: doorkeeper_app, membership: membership, can_login: false

        get authorize_url
        expect(response).to redirect_to("https://localhost:34343/auth/failure?message=unauthorized")
      end
    end
  end
end
