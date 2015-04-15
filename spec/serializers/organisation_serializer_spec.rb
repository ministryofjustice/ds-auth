require "rails_helper"

RSpec.describe OrganisationSerializer do
  describe "#as_json" do
    subject { OrganisationSerializer.new organisation: double("Organisation") }

    it "calls serialize" do
      organisation_hash = double("organisation_hash")
      opts = {}

      expect(subject).to receive(:serialize).and_return(organisation_hash)

      expect(subject.as_json(opts)).to eq(organisation_hash)
    end
  end

  describe "#serialize" do
    it "serializes the profile" do
      organisation = create :organisation
      member_1 = create :profile, name: "Member B", organisations: [organisation]
      member_2 = create :profile, name: "Member A", organisations: [organisation]

      serializer = OrganisationSerializer.new organisation: organisation

      expect(serializer.serialize).to eq(
        {
          organisation: {
            uid: organisation.uid,
            name: organisation.name,
            type: organisation.organisation_type,
            links: {
              profiles: "/api/v1/profiles/uids[]=#{member_2.uid}&uids[]=#{member_1.uid}"
            }
          }
        }
      )
    end
  end
end
