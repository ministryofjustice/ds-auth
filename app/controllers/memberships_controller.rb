class MembershipsController < ApplicationController
  before_action :set_organisation

  def new
    @membership = Membership.new
  end

  def create
    @membership = Membership.new membership_params
    if @membership.save
      redirect_to organisation_path(@organisation), notice: flash_message(:create, Membership)
    else
      render :new
    end
  end

  private

  def set_membership
    @membership = Membership.find(params[:membership_id])
  end

  def set_organisation
    @organisation = Organisation.find(params[:organisation_id])
  end

  def membership_params
    params.require(:membership).
      permit(:profile_id).
      merge({ organisation_id: @organisation.id })
  end

end
