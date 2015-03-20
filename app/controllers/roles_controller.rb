class RolesController < ApplicationController
  before_action :set_role, only: [:show, :edit, :update, :destroy]

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
  end

  def destroy
  end

  private
    def set_role
      @role = Role.find(params[:id])
    end

    def role_params
      params[:role]
    end
end
