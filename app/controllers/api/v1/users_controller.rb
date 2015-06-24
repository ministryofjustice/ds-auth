module Api::V1
  class UsersController < ApiController

    def index
      if params[:uids].present?
        users = User.where(uid: params[:uids])
      else
        users = User.all
      end
      users = users.by_name

      respond_to do |format|
        format.json { render json: users_serializer(users) }
      end
    end

    def show
      user = User.find_by(uid: params[:uid])
      if user.present?
        respond_to do |format|
          format.json { render json: user_serializer(user) }
        end
      else
        respond_to do |format|
          format.json { render json: { "errors" => ["Resource not found"] }, status: 404 }
        end
      end
    end

    def search
      if params[:q].present?
        users = User.where("name ~* ?", params[:q])
      else
        users = User.none
      end
      users = users.by_email

      respond_to do |format|
        format.json { render json: users_serializer(users) }
      end
    end

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

    def users_serializer(users)
      UsersSerializer.new(users)
    end

    def user_serializer(user)
      UserSerializer.new(user)
    end

  end
end
