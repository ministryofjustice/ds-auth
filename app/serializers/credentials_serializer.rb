class CredentialsSerializer
  def initialize(user: )
    @user = user
  end

  def call
    serialize_credentials
  end

  private

  attr_reader :user

  def serialize_credentials
    {
      user: serialized_user,
      profile: serialized_profile,
      roles: serialized_roles,
    }.to_json
  end

  def serialized_user
    {
      id: user.id,
      email: user.email,
      uid: user.uid,
    }
  end

  def serialized_profile
    {
      email: profile.email,
      name:  profile.name,
      telephone: profile.tel,
      mobile: profile.mobile,
      address: {
        full_address: profile.address,
        postcode: profile.postcode,
      },
      organisation_ids: profile.organisations.pluck(:id)
    }
  end

  def serialized_roles
    user.roles.pluck(:name)
  end

  def profile
    user.profile || NullProfile.new
  end
end
