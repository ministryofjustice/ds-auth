require "rails_helper"

RSpec.describe OrganisationSerializer do
  describe "#serialize" do
    it "serializes the profile" do
      organisation = create :organisation
      member_1 = create :profile, name: "Member B", organisations: [organisation]
      member_2 = create :profile, name: "Member A", organisations: [organisation]

      serializer = OrganisationSerializer.new organisation

      expect(serializer.serialize).to eq(
        {
          uid: organisation.uid,
          name: organisation.name,
          type: organisation.organisation_type,
          links: {
            profiles: "/api/v1/profiles?uids[]=#{member_2.uid}&uids[]=#{member_1.uid}",
            parent_organisation: nil,
            sub_organisations: nil
          }
        }
      )
    end
  end
end
