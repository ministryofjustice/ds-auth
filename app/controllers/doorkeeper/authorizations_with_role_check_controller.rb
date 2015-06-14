module Doorkeeper
  class AuthorizationsWithRoleCheckController < Doorkeeper::AuthorizationsController
    def new
      if resource_owner_has_role_for_application?
        super
      else
        redirect_to role_failure_uri
      end
    end

    private

    def resource_owner_has_role_for_application?
      current_resource_owner.memberships.with_any_role(server.client_via_uid.application.available_roles).exists?
    end

    def role_failure_uri
      uri = URI.parse server.client_via_uid.redirect_uri
      uri.path = "/auth/failure"
      uri.query = "message=unauthorized"
      uri.to_s
    end
  end
end
