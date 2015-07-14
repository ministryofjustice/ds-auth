module Doorkeeper
  class CustomApplicationsController < Doorkeeper::ApplicationsController
    private

    def application_params
      if params.respond_to?(:permit)
        params.require(:doorkeeper_application).permit(:name, :redirect_uri, :only_allow_authorized_login, :scopes)
      else
        params[:doorkeeper_application].slice(:name, :redirect_uri, :only_allow_authorized_login, :scopes) rescue nil
      end
    end
  end
end
