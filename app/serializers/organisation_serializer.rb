class OrganisationSerializer < BaseSerializer

  def serialize
    {
      uid: object.uid,
      name: object.name,
      type: object.organisation_type,
      telephone: object.tel,
      parent_organisation_uid: parent_organisation_uid,
      sub_organisation_uids: sub_organisation_uids,
      links: serialized_links
    }.merge organisation_type_specific_fields
  end

  private

  def serialized_links
    {
      users: users_link,
      parent_organisation: parent_organisation_link,
      sub_organisations: sub_organisations_link,
    }
  end

  def serialize_uids(collection)
    collection.map { |obj| "uids[]=#{obj.uid}" }.join("&")
  end

  def parent_organisation_uid
    object.parent_organisation.try(:uid)
  end

  def sub_organisation_uids
    object.sub_organisations.map(&:uid)
  end

  def organisation_type_specific_fields
    if object.is_law_firm?
      {
        supplier_number: object.supplier_number
      }
    else
      {}
    end
  end

  def users_link
    "/api/v1/users?#{serialize_uids(object.users)}" unless object.users.empty?
  end

  def parent_organisation_link
    "/api/v1/organisation/#{object.parent_organisation.uid}" if parent_organisation_uid
  end

  def sub_organisations_link
    "/api/v1/organisations?#{serialize_uids(object.sub_organisations)}" unless object.sub_organisations.empty?
  end
end
