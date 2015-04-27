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
      profiles: profiles_link,
      parent_organisation: parent_organisation_link,
      sub_organisations: sub_organisations_link,
    }
  end

  def serialize_uids(collection)
    collection.map { |obj| "uids[]=#{obj.uid}" }.join("&")
  end

  def profiles_link
    "/api/v1/profiles?#{serialize_uids(object.profiles)}" unless object.profiles.empty?
  end

  def parent_organisation_link
    "/api/v1/organisation/#{object.parent_organisation.uid}" if object.parent_organisation.try(:uid)
  end

  def sub_organisations_link
    "/api/v1/organisations?#{serialize_uids(object.sub_organisations)}" unless object.sub_organisations.empty?
  end
end
