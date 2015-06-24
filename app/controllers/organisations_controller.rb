class OrganisationsController < ApplicationController
  before_action :set_organisation, except: [:index, :new, :create]
  after_action :verify_authorized, except: :index
  after_action :verify_policy_scoped, only: :index

  def index
    @organisations = policy_scope(Organisation)
  end

  def show
    authorize @organisation
  end

  def new
    @organisation = Organisation.new
    authorize @organisation
  end

  def create
    @organisation = Organisation.new(organisation_params)

    authorize @organisation

    if @organisation.save
      redirect_to organisations_path, notice: flash_message(:create, Organisation)
    else
      render :new
    end
  end

  def edit
    authorize @organisation
  end

  def update
    authorize @organisation

    if @organisation.update_attributes organisation_params
      redirect_to organisation_path(@organisation), notice: flash_message(:update, Organisation)
    else
      render :edit
    end
  end

  def destroy
    authorize @organisation

    if @organisation.destroy
      redirect_to organisations_path, notice: flash_message(:destroy, Organisation)
    else
      redirect_to organisations_path, notice: flash_message(:failed_destroy, Organisation)
    end
  end

  private

  def set_organisation
    @organisation = policy_scope(Organisation).find params[:id]
  end

  def organisation_params
    permitted_attributes(@organisation || Organisation.new)
  end
end
