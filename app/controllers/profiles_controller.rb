class ProfilesController < ApplicationController
  before_action :find_profile, except: [:index, :new, :create]
  before_action :new_profile_form, only: [:show, :new, :create, :edit, :update]

  def index
    @profiles = Profile.all
  end

  def show
  end

  def new
  end

  def create
    if @profile_form.submit(profile_params)
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

  def profile
    @profile ||= Profile.new
  end

  def find_profile
    @profile = Profile.find(params[:id])
  end

  def new_profile_form
    @profile_form ||= ProfileForm.new profile
  end


  def profile_params
    params.require(:profile).permit(:user_id,
                                    :name,
                                    :tel,
                                    :mobile,
                                    :address,
                                    :postcode,
                                    :email,
                                    :associated_user,
                                    user_attributes: [:password, :password_confirmation])
  end
end
