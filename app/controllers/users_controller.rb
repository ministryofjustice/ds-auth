class UsersController < ApplicationController
  before_action :set_user

  def edit
  end

  def update
    if @user.update_attributes user_params
      redirect_to profiles_path, notice: flash_message(:update, User)
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
