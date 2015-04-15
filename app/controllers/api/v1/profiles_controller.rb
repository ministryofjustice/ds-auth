module Api::V1
  class ProfilesController < ApiController

    def index
      if params[:uids].present?
        profiles = Profile.where(uid: params[:uids])
      else
        profiles = Profile.all
      end
      profiles = profiles.by_name

      respond_to do |format|
        format.json { render json: profiles_serializer(profiles) }
      end
    end

    def show
      profile = Profile.find_by(uid: params[:uid])
      if profile.present?
        respond_to do |format|
          format.json { render json: profile_serializer(profile) }
        end
      else
        respond_to do |format|
          format.json { render json: { "errors" => ["Resource not found"] }, status: 404 }
        end
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
