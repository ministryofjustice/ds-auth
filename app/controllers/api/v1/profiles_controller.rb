module Api::V1
  class ProfilesController < ApiController

    def index
      profiles = Profile.by_name
      render json: profiles_serializer(profiles)
    end

    def show
      profile = Profile.find_by(uid: params[:uid])
      if profile.present?
        render json: profile_serializer(profile)
      else
        render json: { "errors" => ["Resource not found"] }, status: 404
      end
    end

    private

    def profiles_serializer(profiles)
      ProfilesSerializer.new(
        profiles: profiles
      )
    end

    def profile_serializer(profile)
      ProfileSerializer.new(
        profile: profile
      )
    end

  end
end
