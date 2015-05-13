require "rails_helper"

RSpec.describe OrganisationSerializer do
  describe "#serialize" do
    it "serializes the profile" do
      parent_organisation = create :organisation
      organisation = create :organisation, parent_organisation: parent_organisation
      member_1 = create :profile, name: "Member B", organisations: [organisation]
      member_2 = create :profile, name: "Member A", organisations: [organisation]

      sub_organisation1 = create :organisation, parent_organisation: organisation
      sub_organisation2 = create :organisation, parent_organisation: organisation

      serializer = OrganisationSerializer.new organisation

      expect(serializer.serialize).to eq(
        {
          uid: organisation.uid,
          name: organisation.name,
          type: organisation.organisation_type,
          parent_organisation_uid: parent_organisation.uid,
          sub_organisation_uids: [sub_organisation1.uid, sub_organisation2.uid],
          links: {
            profiles: "/api/v1/profiles?uids[]=#{member_2.uid}&uids[]=#{member_1.uid}",
            parent_organisation: "/api/v1/organisation/#{parent_organisation.uid}",
            sub_organisations: "/api/v1/organisations?uids[]=#{sub_organisation1.uid}&uids[]=#{sub_organisation2.uid}"
          }
        }
      )
    end
  end
end
