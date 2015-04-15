class ProfilesSerializer
  def initialize(profiles:)
    @profiles = profiles
  end

  def as_json(opts = {})
    serialize
  end

  def serialize
    {
      profiles: serialized_profiles
    }
  end

  private

  attr_reader :profiles


  def serialized_profiles
    profiles.map do |p|
      {
        uid: p.uid,
        name: p.name,
        # type: p.type,
        links: serialized_links(p)
      }
    end
  end

  def serialized_links(profile)
    {
      organisation: "/api/v1/organisations/#{profile.organisations.first.id}"
    }
  end
end
