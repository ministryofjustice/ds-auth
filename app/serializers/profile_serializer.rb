class ProfileSerializer
  def initialize(profile:)
    @profile = profile
  end

  def to_json(opts = {})
    serialize.to_json opts
  end

  private

  attr_reader :profile

  def serialize
    {
      profile: serialized_profile
    }
  end

  def serialized_profile
    {
      uid: profile.uid,
      name: profile.name,
      # type: profile.type,
      links: serialized_links
    }
  end

  def serialized_links
    {
      organisation: "/api/v1/organisation/#{profile.organisations.first.id}"
    }
  end
end
