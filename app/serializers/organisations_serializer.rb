class OrganisationsSerializer
  def initialize(organisations:)
    @organisations = organisations
  end

  def as_json(opts = {})
    serialize
  end

  def serialize
    {
      organisations: serialized_organisations
    }
  end

  private

  attr_reader :organisations


  def serialized_organisations
    organisations.map do |o|
      {
        uid: o.uid,
        name: o.name,
        type: o.organisation_type,
        links: serialized_links(o)
      }
    end
  end

  def serialized_links(organisation)
    {
      profiles: "/api/v1/profiles/" + serialized_profile_ids(organisation)
    }
  end

  def serialized_profile_ids(organisation)
    organisation.profiles.by_name.map do |profile|
      "uids[]=#{profile.uid}"
    end.join("&")
  end
end
