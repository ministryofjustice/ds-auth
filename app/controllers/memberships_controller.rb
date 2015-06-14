class MembershipsController < ApplicationController
  before_action :set_membership, only: [:edit, :update, :destroy]
  before_action :set_organisation

  def new
    @membership = Membership.new roles: @organisation.default_roles
    @users = User.where.not(id: @organisation.user_ids)
  end

  def create
    @membership = Membership.new membership_params
    if @membership.save
      redirect_to organisation_path(@organisation), notice: flash_message(:create, Membership)
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @membership.update membership_params
      redirect_to organisation_path(@organisation), notice: flash_message(:update, Membership)
    else
      render :edit
    end
  end

  def destroy
    if @membership.destroy
      redirect_to organisation_path(@organisation), notice: flash_message(:destroy, Membership)
    else
      redirect_to organisation_path(@organisation), notice: flash_message(:failed_destroy, Membership)
    end
  end

  private

  def set_membership
    @membership = Membership.find(params[:id])
  end

  def set_organisation
    @organisation = Organisation.find(params[:organisation_id])
  end

  def membership_params
    params.require(:membership).
      permit(:user_id, roles: [], applications: []).
      merge({ organisation_id: @organisation.id })
  end

end
