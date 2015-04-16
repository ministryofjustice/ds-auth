class OrganisationSerializer < BaseSerializer

  def serialize
    {
      uid: object.uid,
      name: object.name,
      type: object.organisation_type,
      links: serialized_links
    }
  end

  private

  def serialized_links
    {
      profiles: "/api/v1/profiles/" + serialized_profile_ids
    }
  end

  def serialized_profile_ids
    object.profiles.by_name.map do |profile|
      "uids[]=#{profile.uid}"
    end.join("&")
  end
end
