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
    ActiveModel::Name.new(self, nil, 'Profile')
  end

  def initialize(profile)
    @profile = profile
  end

  def submit(params)
    if params[:associated_user] == '1'
      params[:user_attributes].merge!(email: params[:email])
    else
      params.except!(:user_attributes)
    end

    @profile.assign_attributes params

    if @profile.valid?
      @profile.save!
      true
    else
      add_errors_to_form
      false
    end
  end

  def add_errors_to_form
    @profile.errors.messages.each do |field_name, error_message|
      self.errors[field_name] = error_message.join ", "
    end
  end
end

