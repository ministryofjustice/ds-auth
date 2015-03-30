module Api::V1
  class CredentialsController < ApiController
    respond_to :json

    def show
      render json: CredentialsSerializer.new(current_resource_owner).call
    end
  end
end
