class ProfileForm
  include ActiveModel::Model
  extend Forwardable

  attr_reader :profile

  PROFILE_DELEGATED_ATTRIBUTES = :name, :tel, :mobile, :address, :postcode, :email
  USER_DELEGATED_ATTRIBUTES = :password, :password_confirmation

  PROFILE_DELEGATED_ATTRIBUTES.each do |attr_name|
    def_delegator :@profile, "#{attr_name}_before_type_cast", attr_name
  end

  USER_DELEGATED_ATTRIBUTES.each do |attr_name|
    def_delegator :@user, "#{attr_name}_before_type_cast", attr_name
  end

  def self.model_name
    ActiveModel::Name.new(self, nil, "Profile")
  end

  def initialize(profile)
    @profile = profile
  end

  def submit(params)
    @profile.assign_attributes correct_associated_user_params(params)

    if @profile.valid?
      unless @profile.save
        self.errors[:profile] = "could not be saved"
        return false
      end
    else
      add_errors_to_form
      return false
    end
    true
  end

  def add_errors_to_form
    @profile.errors.messages.each do |field_name, error_message|
      self.errors[field_name] = error_message.join ", "
    end
  end

  private

  def correct_associated_user_params(params)
    if associated_user?(params)
      params[:user_attributes].merge!(email: params[:email])
    else
      params.except!(:user_attributes)
    end
    params
  end

  def associated_user?(params)
    associated_user = params[:associated_user]
    associated_user.present? && associated_user != "0"
  end
end

