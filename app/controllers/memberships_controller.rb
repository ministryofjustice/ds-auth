class MembershipsController < ApplicationController
  before_action :set_organisation
  before_action :set_membership, only: [:edit, :update, :destroy]
  after_action :verify_authorized, except: :index

  def new
    # We only add existing Users here - new users get added to an Organisation in Users#create
    user = User.find_by_uid!(params[:user_uid])

    @membership = Membership.new user: user, organisation: @organisation

    authorize @membership

    build_all_available_applications_for_organisation
  end

  def create
    @membership = Membership.new membership_params

    authorize @membership

    if @membership.save
      redirect_to organisation_path(@organisation), notice: flash_message(:create, Membership)
    else
      build_all_available_applications_for_organisation
      render :new
    end
  end

  def edit
    authorize @membership

    build_all_available_applications_for_organisation
  end

  def update
    authorize @membership
    
    if @membership.update membership_params
      redirect_to organisation_path(@organisation), notice: flash_message(:update, Membership)
    else
      build_all_available_applications_for_organisation
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
    params.require(:membership).permit(
      :user_id, :is_organisation_admin, application_memberships_attributes: [:id, :application_id, :can_login, roles: []]
    ).tap do |whitelisted|
      whitelisted[:organisation_id] = @organisation.id
      if whitelisted[:application_memberships_attributes]
        whitelisted[:application_memberships_attributes].each do |index, attrs|
          attrs[:roles].reject!{|r| r.blank?}
        end
      end
    end
  end

  def build_all_available_applications_for_organisation
    # Remove any applications that the Organisation does not have access to
    # This can happen if application ids are manually added to POST or PATCH requests
    applications_not_available = @membership.application_memberships.select do |application_membership|
      @organisation.application_ids.exclude? application_membership.application_id
    end

    @membership.application_memberships.destroy applications_not_available

    # Add any missing applications that the Organisation has access to
    @organisation.applications.each do |app|
      @membership.application_memberships.build application: app unless app.id.in? @membership.application_memberships.map(&:application_id)
    end
  end
end
