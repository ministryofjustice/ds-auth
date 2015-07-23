require "rails_helper"

RSpec.describe Doorkeeper::CustomApplicationsController, type: :controller do
  describe "GET index" do
    it "redirects to the login path when not logged in" do
      get :index

      expect(response).to redirect_to new_user_session_path
    end

    it "redirects to root when not a webops user" do
      sign_in create(:user)

      get :index

      expect(response).to redirect_to root_path
    end

    it "allows access to webops users" do
      sign_in create(:user, :webops)

      get :index

      expect(response).to render_template :index
    end
  end
end
