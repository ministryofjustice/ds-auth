class OrganisationsController < ApplicationController
  before_action :set_organisation, except: [:index, :new, :create]

  def index
    @organisations = Organisation.all
  end

  def show
  end

  def new
    @organisation = Organisation.new
  end

  def create
    @organisation = Organisation.new(organisation_params)
    if @organisation.save
      redirect_to organisations_path, notice: flash_message(:create, Organisation)
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @organisation.update_attributes organisation_params
      redirect_to organisations_path, notice: flash_message(:update, Organisation)
    else
      render :edit
    end
  end

  def destroy
    if @organisation.destroy
      redirect_to organisations_path, notice: flash_message(:destroy, Organisation)
    else
      redirect_to organisations_path, notice: flash_message(:failed_destroy, Organisation)
    end
  end

  private

  def set_organisation
    @organisation = Organisation.find(params[:id])
  end

  def organisation_params
    params.require(:organisation)
          .permit(:slug,
                  :name,
                  :organisation_type,
                  :searchable,
                  :tel,
                  :addressable,
                  :postcode,
                  :email)
  end
end
