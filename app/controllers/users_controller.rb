class UsersController < ApplicationController
  before_action :set_user, except: [:index, :new, :create]
  after_action :verify_authorized, except: :index
  after_action :verify_policy_scoped, only: :index

  def index
    @users = policy_scope(User)
  end

  def show
    authorize @user
  end

  def new
    @user = User.new
    authorize @user
  end

  def create
    @user = User.new user_params

    authorize @user

    if @user.save
      current_user.organisations.each do |organisation|
        organisation.memberships.create user: @user, roles: organisation.default_roles
      end
      redirect_to user_path(@user), notice: flash_message(:create, User)
    else
      render :new
    end
  end

  def edit
    authorize @user
  end

  def update
    authorize @user

    if update_user
      redirect_to user_path(@user), notice: flash_message(:update, User)
    else
      render :edit
    end
  end

  def destroy
    authorize @user

    if @user.destroy
      redirect_to users_path, notice: flash_message(:destroy, User)
    else
      redirect_to users_path, notice: flash_message(:failed_destroy, User)
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation,
      :name, :telephone, :mobile, :address, :postcode, :email)
  end

  def update_user
    if user_params[:password].blank?
      @user.update_without_password user_params
    else
      @user.update_attributes user_params
    end
  end

end
