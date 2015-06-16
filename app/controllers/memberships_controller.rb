class MembershipsController < ApplicationController
  before_action :set_membership, only: [:edit, :update, :destroy]
  before_action :set_organisation

  def new
    user = User.find(params[:user_id])

    redirect_if_user_already_member user

    @membership = Membership.new user: user, roles: @organisation.default_role_names
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

  def redirect_if_user_already_member(user)
    if membership = @organisation.memberships.where(user: user).first
      redirect_to(
        edit_organisation_membership_path(@organisation, membership),
        notice: t("user_already_member_of_organisation", organisation_name: @organisation.name)
      )
    end
  end

end
