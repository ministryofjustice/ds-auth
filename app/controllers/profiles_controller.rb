class ProfilesController < ApplicationController
  before_action :set_profile, except: [:index, :new, :create]

  def index
    @profiles = Profile.all
  end

  def show
  end

  def new
    @profile = Profile.new
  end

  def create
    @profile = Profile.new(profile_params)
    if @profile.save
      redirect_to profiles_path, notice: flash_message(:create, Profile)
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @profile.update_attributes profile_params
      redirect_to profiles_path, notice: flash_message(:update, Profile)
    else
      render :edit
    end
  end

  def destroy
    if @profile.destroy
      redirect_to profiles_path, notice: flash_message(:destroy, Profile)
    else
      redirect_to profiles_path, notice: flash_message(:failed_destroy, Profile)
    end
  end

  private

  def set_profile
    @profile = Profile.find(params[:id])
  end

  def profile_params
    params.require(:profile)
          .permit(:user_id,
                  :name,
                  :tel,
                  :address,
                  :postcode,
                  :email)
  end
end
