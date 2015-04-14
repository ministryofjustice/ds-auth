module Api::V1
  class CredentialsController < ApiController

    def show
      respond_as_json credentials_serializer
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
