class ProfileSerializer < BaseSerializer

  def serialize
    {
      uid: object.uid,
      name: object.name,
      links: serialized_links
    }
  end

  private

  def serialized_links
    {
      organisation: "/api/v1/organisations/#{object.organisations.first.uid}"
    }
  end
end
