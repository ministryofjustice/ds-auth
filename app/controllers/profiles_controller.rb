class ProfilesController < ApplicationController
  before_action :set_profile, except: [:index, :new, :create]

  def index
    @profiles = Profile.all
  end

  def show
  end

  def new
    @profile_form = CreateProfileForm.new
  end

  def create
    @profile_form = CreateProfileForm.new(profile_form_params)

    if @profile_form.save
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
              :mobile,
              :address,
              :postcode,
              :email)
  end

  def profile_form_params
    params.require(:create_profile_form).permit(:name,
                                                :tel,
                                                :mobile,
                                                :address,
                                                :postcode,
                                                :email,
                                                :associated_user,
                                                :password,
                                                :password_confirmation)
  end
end
