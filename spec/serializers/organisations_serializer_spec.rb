require "rails_helper"

RSpec.describe OrganisationsSerializer do
  describe "#as_json" do
    subject { OrganisationsSerializer.new organisations: double("Organisations") }

    it "calls serialize" do
      organisations_hash = double("organisations")
      opts = {}

      expect(subject).to receive(:serialize).and_return(organisations_hash)

      expect(subject.as_json(opts)).to eq(organisations_hash)
    end
  end

  describe "#serialize" do
    it "serializes all profiles in the provided order" do
      org_1 = create :organisation
      org_2 = create :organisation
      org_1_member = create :profile, organisations: [org_1]
      org_2_member = create :profile, organisations: [org_2]

      serializer = OrganisationsSerializer.new organisations: [org_1, org_2]

      expect(serializer.serialize).to eq(
        organisations: [
          {
            uid: org_1.uid,
            name: org_1.name,
            type: org_1.organisation_type,
            links: {
              profiles: "/api/v1/profiles/uids[]=#{org_1_member.uid}"
            }
          },
          {
            uid: org_2.uid,
            name: org_2.name,
            type: org_2.organisation_type,
            links: {
              profiles: "/api/v1/profiles/uids[]=#{org_2_member.uid}"
            }
          }
        ]
      )
    end
  end
end
