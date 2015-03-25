class UsersController < ApplicationController
  before_action :set_user, except: [:index, :new, :create]

  def index
    @users = User.all
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to users_path, notice: flash_message(:create, User)
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @user.update_attributes user_params
      redirect_to users_path, notice: flash_message(:update, User)
    else
      render :edit
    end
  end

  def destroy
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
    params.require(:user).permit(:email, :password, :password_confirmation)
  end

end
