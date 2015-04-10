module Api::V1
  class CredentialsController < ApiController
    respond_to :json

    def show
      render json: credentials_serializer.call
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
