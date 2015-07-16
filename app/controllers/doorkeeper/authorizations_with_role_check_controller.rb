module Doorkeeper
  class AuthorizationsWithRoleCheckController < Doorkeeper::AuthorizationsController
    def new
      if application.handles_own_authorization?
        super
      else
        if resource_owner_has_role_for_application?
          super
        else
          redirect_to role_failure_uri
        end
      end
    end

    private

    def resource_owner_has_role_for_application?
      current_resource_owner.memberships.with_any_role(*application.available_role_names).exists?
    end

    def role_failure_uri
      redirect_uri = authorization.authorize.redirect_uri

      host = URI.parse(redirect_uri).host
      correct_uri = (application.failure_uri || "").split.detect { |uri| uri.match host }

      if correct_uri.present?
        uri = URI.parse correct_uri
      else
        uri = URI.parse redirect_uri
        uri.path = "/auth/failure"
        uri.query = "message=unauthorized"
      end
      uri.to_s
    end

    def application
      server.client_via_uid.application
    end
  end
end
