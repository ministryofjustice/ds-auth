class RolesController < ApplicationController
  before_action :set_role, except: [:index, :new, :create]

  def index
    @roles = Role.all
  end

  def show
  end

  def new
    @role = Role.new
  end

  def create
    @role = Role.new(role_params)
    if @role.save
      redirect_to roles_path, notice: flash_message(:create, Role)
    else
      render :new
    end
  end

  def destroy
    if @role.destroy
      redirect_to roles_path, notice: flash_message(:destroy, Role)
    else
      redirect_to roles_path, notice: flash_message(:failed_destroy, Role)
    end
  end

  private

  def set_role
    @role = Role.find(params[:id])
  end

  def role_params
    params.require(:role)
          .permit(:name)
  end
end
