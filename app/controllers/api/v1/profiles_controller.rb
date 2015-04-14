module Api::V1
  class ProfilesController < ApiController

    def show
      begin
        profile = Profile.find_by!(uid: params[:uid])
        respond_as_json profile_serializer(profile)
      rescue ActiveRecord::RecordNotFound
        render json: { "errors" => ["Resource not found"] }, status: 404
      end
    end

    private

    def profile_serializer(profile)
      ProfileSerializer.new(
        profile: profile
      )
    end

  end
end
