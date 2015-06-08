class ProfileForm < Reform::Form
  include Composition
  include Reform::Form::ActiveRecord

  property :name, on: :profile
  property :email, on: :profile
  property :tel, on: :profile
  property :mobile, on: :profile
  property :address, on: :profile
  property :postcode, on: :profile

  model :profile

  property :password, on: :user
  property :password_confirmation, on: :user, empty: true

  validates :name, :address, :postcode, :email, presence: true

  validates :email, uniqueness: true, email: { strict_mode: true }

  validates :password, presence: true,
    confirmation: true, length: { minimum: 8 }, if: :has_associated_user?


  attr_accessor :has_associated_user
  alias :has_associated_user? :has_associated_user

  def validate(params)
    @has_associated_user = params.delete(:has_associated_user)
    super(params)
  end

  def email=(val)
    super(val)
    model[:user].email = val
  end



  def active_for_authentication?
    true
  end

  def authenticatable_salt
    model[:user].authenticatable_salt
  end

  def save
    return false unless valid?
    sync
    profile = model[:profile]
    profile.user = model[:user] if has_associated_user?
    profile.save
  end
end

