module Api::V1
  class ProfilesController < ApiController

    def show
      profile = Profile.find_by(uid: params[:uid])
      if profile.present?
        render json: profile_serializer(profile)
      else
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
