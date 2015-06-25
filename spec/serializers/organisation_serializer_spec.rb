require "rails_helper"

RSpec.describe OrganisationSerializer do
  describe "#serialize" do
    it "serializes the Organisation" do
      parent_organisation = create :organisation
      organisation = create :organisation, parent_organisation: parent_organisation
      member_1 = create :user, name: "Member B", id: 231, organisations: [organisation]
      member_2 = create :user, name: "Member A", id: 123, organisations: [organisation]

      sub_organisation1 = create :organisation, parent_organisation: organisation
      sub_organisation2 = create :organisation, parent_organisation: organisation

      serializer = OrganisationSerializer.new organisation

      expect(serializer.serialize).to eq(
        {
          uid: organisation.uid,
          name: organisation.name,
          type: organisation.organisation_type,
          telephone: organisation.tel,
          parent_organisation_uid: parent_organisation.uid,
          sub_organisation_uids: [sub_organisation1.uid, sub_organisation2.uid],
          links: {
            users: "/api/v1/users?uids[]=#{member_2.uid}&uids[]=#{member_1.uid}",
            parent_organisation: "/api/v1/organisation/#{parent_organisation.uid}",
            sub_organisations: "/api/v1/organisations?uids[]=#{sub_organisation1.uid}&uids[]=#{sub_organisation2.uid}"
          }
        }
      )
    end

    context "Organisation is a law_firm" do
      it "also serializes supplier_number" do
        organisation = create :organisation, organisation_type: "law_firm", supplier_number: "abc123"

        serializer = OrganisationSerializer.new organisation

        expect(serializer.serialize).to include({ supplier_number: "abc123" })
      end
    end
  end
end
