module Doorkeeper
  class CustomApplicationsController < Doorkeeper::ApplicationsController
    before_action :authenticate_webops!

    protected

    def authenticate_webops!
      unless current_user.is_webops?
        user_not_authorized
      end
    end

    def user_not_authorized
      flash[:alert] = t("not_authorized")
      redirect_to(request.referrer || root_path)
    end

    private

    def application_params
      if params.respond_to?(:permit)
        params.require(:doorkeeper_application).permit(:name, :redirect_uri, :failure_uri, :handles_own_authorization, :scopes, :available_roles_as_string)
      else
        (params[:doorkeeper_application] || {}).slice(:name, :redirect_uri, :failure_uri, :handles_own_authorization, :scopes, :available_roles_as_string)
      end
    end
  end
end
