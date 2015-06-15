class UsersController < ApplicationController
  before_action :load_organisation, only: [:new, :create]
  before_action :set_user, except: [:index, :new, :create]
  after_action :verify_authorized, except: :index
  after_action :verify_policy_scoped, only: :index

  def index
    @users = policy_scope(User)
  end

  def show
    authorize @user
  end

  def new
    @user = BuildUserWithMembership.new(
      organisation: @organisation,
      membership_params: { roles: @organisation.default_role_names }
    ).call

    authorize @user
  end

  def create
    @user = BuildUserWithMembership.new(
      organisation: @organisation,
      user_params: user_params.except(:membership),
      membership_params: user_params[:membership] || {}
    ).call

    authorize @user

    if @user.save
      redirect_to user_path(@user), notice: flash_message(:create, User)
    else
      customize_user_already_exists_error_message @user, @organisation
      render :new
    end
  end

  def edit
    authorize @user
  end

  def update
    authorize @user

    if update_user
      redirect_to user_path(@user), notice: flash_message(:update, User)
    else
      render :edit
    end
  end

  def destroy
    authorize @user

    if @user.destroy
      redirect_to users_path, notice: flash_message(:destroy, User)
    else
      redirect_to users_path, notice: flash_message(:failed_destroy, User)
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def load_organisation
    @organisation = Organisation.find params[:organisation_id]
  end

  def user_params
    permitted_attributes(@user || User.new)
  end

  def update_user
    if user_params[:password].blank?
      @user.update_without_password user_params
    else
      @user.update_attributes user_params
    end
  end

  def customize_user_already_exists_error_message(user, organisation)
    if user.errors[:email] == ["has already been taken"]
      existing_user = User.find_by_email(user.email)
      link = new_organisation_membership_path(organisation, user_id: existing_user.id)
      user.errors[:email] << "<a href=\"#{link}\">Click here to add #{user.email} to #{organisation.name}</a>"
    end
  end
end
