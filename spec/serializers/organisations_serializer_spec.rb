require "rails_helper"

RSpec.describe OrganisationsSerializer do
  describe "#serialize" do
    it "serializes all organisations in the provided order" do
      org_1 = create :organisation
      org_2 = create :organisation
      org_1_member = create :profile, organisations: [org_1]
      org_2_member = create :profile, organisations: [org_2]

      serializer = OrganisationsSerializer.new [org_1, org_2]

      expect(serializer.serialize).to eq(
        [
          {
            uid: org_1.uid,
            name: org_1.name,
            type: org_1.organisation_type,
            parent_organisation_uid: nil,
            sub_organisation_uids: [],
            links: {
              profiles: "/api/v1/profiles?uids[]=#{org_1_member.uid}",
              parent_organisation: nil,
              sub_organisations: nil
            }
          },
          {
            uid: org_2.uid,
            name: org_2.name,
            type: org_2.organisation_type,
            parent_organisation_uid: nil,
            sub_organisation_uids: [],
            links: {
              profiles: "/api/v1/profiles?uids[]=#{org_2_member.uid}",
              parent_organisation: nil,
              sub_organisations: nil
            }
          }
        ]
      )
    end
  end
end
