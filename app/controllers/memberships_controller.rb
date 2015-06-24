class MembershipsController < ApplicationController
  before_action :set_organisation
  before_action :set_membership, only: [:edit, :update, :destroy]
  after_action :verify_authorized, except: :index

  def new
    # We only add existing Users here - new users get added to an Organisation in Users#create
    user = User.find_by_uid!(params[:user_uid])

    @membership = Membership.new user: user, organisation: @organisation, roles: @organisation.default_role_names

    authorize @membership
  end

  def create
    @membership = Membership.new membership_params

    authorize @membership

    if @membership.save
      redirect_to organisation_path(@organisation), notice: flash_message(:create, Membership)
    else
      render :new
    end
  end

  def edit
    authorize @membership
  end

  def update
    authorize @membership

    if @membership.update membership_params
      redirect_to organisation_path(@organisation), notice: flash_message(:update, Membership)
    else
      render :edit
    end
  end

  def destroy
    authorize @membership

    if @membership.destroy
      redirect_to organisation_path(@organisation), notice: flash_message(:destroy, Membership)
    else
      redirect_to organisation_path(@organisation), notice: flash_message(:failed_destroy, Membership)
    end
  end

  private

  def set_membership
    @membership ||= set_organisation.memberships.find(params[:id])
  end

  def set_organisation
    @organisation ||= Organisation.find(params[:organisation_id])
  end

  def membership_params
    params.require(:membership).
      permit(:user_id, roles: [], applications: []).
      merge({ organisation_id: @organisation.id })
  end
end
