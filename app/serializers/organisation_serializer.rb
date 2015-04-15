class OrganisationSerializer
  def initialize(organisation:)
    @organisation = organisation
  end

  def as_json(opts = {})
    serialize
  end

  def serialize
    {
      organisation: serialized_organisation
    }
  end

  private

  attr_reader :organisation

  def serialized_organisation
    {
      uid: organisation.uid,
      name: organisation.name,
      type: organisation.organisation_type,
      links: serialized_links
    }
  end

  def serialized_links
    {
      profiles: "/api/v1/profiles/" + serialized_profile_ids
    }
  end

  def serialized_profile_ids
    organisation.profiles.by_name.map do |profile|
      "uids[]=#{profile.uid}"
    end.join("&")
  end
end
