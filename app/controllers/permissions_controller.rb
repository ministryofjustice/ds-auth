class PermissionsController < ApplicationController
  before_action :set_permission, only: :destroy

  def index
    @permissions = Permission.all
  end

  def new
    @user = User.find(params[:user_id])
    @organisation = Organisation.find(params[:organisation_id])
    @permission = Permission.new organisation: @organisation, user: @user
    @redirect_path = params[:redirect_path]
  end

  def create
    @permission = Permission.new(permission_params)
    if @permission.save
      redirect_to_supplied_path_or permissions_path, notice: flash_message(:create, Permission)
    else
      render :new
    end
  end

  def destroy
    if @permission.destroy
      redirect_to permissions_path, notice: flash_message(:destroy, Permission)
    else
      redirect_to permissions_path, notice: flash_message(:failed_destroy, Permission)
    end
  end

  private

  def set_permission
    @permission = Permission.find(params[:id])
  end

  def permission_params
    params.require(:permission)
          .permit(:user_id,
                  :role_id,
                  :application_id,
                  :organisation_id)
  end

  def redirect_to_supplied_path_or other_path, *args
    redirect_to (params[:redirect_path] || other_path), *args
  end
end
