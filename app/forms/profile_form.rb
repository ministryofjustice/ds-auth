class ProfileForm
  include Virtus.model
  include ActiveModel::Model

  attr_reader :profile
  attr_reader :user

  attribute :name, String
  attribute :tel, String
  attribute :mobile, String
  attribute :address, String
  attribute :postcode, String
  attribute :email, String
  attribute :associated_user, String
  attribute :password, String
  attribute :password_confirmation, String

  validates :name, :tel, :mobile, :address, :postcode, :email, presence: true
  validates :password, :password_confirmation, presence: true, if: :associated_user?

  def persisted?
    false
  end

  def save
    if valid?
      persist!
      true
    else
      false
    end
  end

  private

  def persist!
    @profile = Profile.create!(name: name,
                               tel: tel,
                               mobile: mobile,
                               address: address,
                               postcode: postcode,
                               email: email)
    if associated_user?
      @user = @profile.create_user!(email: email,
                                    password: password,
                                    password_confirmation: password_confirmation)
    end
  end

  def associated_user?
    associated_user != '0'
  end
end