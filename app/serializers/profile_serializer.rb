class ProfileSerializer
  def initialize(profile:)
    @profile = profile
  end

  def as_json(opts = {})
    serialize
  end

  private

  attr_reader :profile

  def serialize
    {
      "profile" => serialized_profile
    }
  end

  def serialized_profile
    {
      "uid" => profile.uid,
      "name" => profile.name,
      # type: profile.type,
      "links" => serialized_links
    }
  end

  def serialized_links
    {
      "organisation" => "/api/v1/organisations/#{profile.organisations.first.id}"
    }
  end
end
