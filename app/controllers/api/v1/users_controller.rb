module Api::V1
  class UsersController < ApiController
    def me
      respond_to do |format|
        format.json { render json: credentials_serializer }
      end
    end

    private

    def credentials_serializer
      CredentialsSerializer.new(
        user: current_resource_owner,
        application: doorkeeper_token.application
      )
    end
  end
end
