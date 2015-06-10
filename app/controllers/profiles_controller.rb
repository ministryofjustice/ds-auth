class ProfilesController < ApplicationController
  before_action :find_profile, only: [:show, :destroy]
  before_action :new_profile_form, only: [:new, :create]
  before_action :edit_profile_form, only: [:edit, :update]

  def index
    @profiles = Profile.all
  end

  def create
    if new_profile_form.validate_and_save(profile_params)
      redirect_to profile_path(new_profile_form), notice: flash_message(:create, Profile)
    else
      render :new
    end
  end

  def update
    if edit_profile_form.validate_and_save(profile_params)
      redirect_to(profile_path(edit_profile_form), notice: flash_message(:update, Profile))
    else
      render :edit
    end
  end

  def destroy
    if find_profile.destroy
      redirect_to profiles_path, notice: flash_message(:destroy, Profile)
    else
      redirect_to profiles_path, notice: flash_message(:failed_destroy, Profile)
    end
  end

  private

  def find_profile
    @profile = Profile.find params[:id]
  end

  def find_profile_user
    find_profile.try(:user) || User.new
  end

  def new_profile_form
    @profile_form ||= ProfileForm.new profile: Profile.new, user: User.new
  end

  def edit_profile_form
    @profile_form ||= ProfileForm.new profile: find_profile, user: find_profile_user, has_associated_user: has_associated_user
  end

  def has_associated_user
    find_profile.try(:user).present?
  end

  def profile_params
    params.require(:profile).permit(:name,
                                    :tel,
                                    :mobile,
                                    :address,
                                    :postcode,
                                    :email,
                                    :has_associated_user,
                                    :password, :password_confirmation)
  end
end
