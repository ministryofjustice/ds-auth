module Doorkeeper
  class CustomApplicationsController < Doorkeeper::ApplicationsController
    private

    def application_params
      if params.respond_to?(:permit)
        params.require(:doorkeeper_application).permit(:name, :redirect_uri, :handles_own_authorization, :scopes)
      else
        params[:doorkeeper_application].slice(:name, :redirect_uri, :handles_own_authorization, :scopes) rescue nil
      end
    end
  end
end
