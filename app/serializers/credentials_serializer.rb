class CredentialsSerializer
  def initialize(user: , application:)
    @user, @application = user, application
  end

  def as_json(opts = {})
    serialize
  end

  private

  attr_reader :user, :application

  def serialize
    {
      "user" => serialized_user,
      "profile" => serialized_profile,
      "roles" => serialized_roles,
    }
  end

  def serialized_user
    {
      "email" => user.email,
    }
  end

  def serialized_profile
    {
      "email" => profile.email,
      "name" => profile.name,
      "telephone" => profile.tel,
      "mobile" => profile.mobile,
      "address" => {
        "full_address" => profile.address,
        "postcode" => profile.postcode,
      },
      "organisation_ids" => profile.organisations.pluck(:id),
      "uid" => profile.uid,
    }
  end

  def serialized_roles
    user.roles_for(application: application).map(&:name)
  end

  def profile
    user.profile || NullProfile.new
  end
end
