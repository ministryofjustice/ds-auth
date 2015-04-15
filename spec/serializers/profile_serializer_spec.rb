require "rails_helper"

RSpec.describe ProfileSerializer do
  describe "#serialize" do
    let(:organisation) { build_stubbed :organisation }
    let(:profile) { build_stubbed :profile, organisations: [organisation] }

    it "serializes the profile" do
      serializer = ProfileSerializer.new profile

      expect(serializer.serialize).to eq(
        {
          uid: profile.uid,
          name: profile.name,
          links: {
            organisation: "/api/v1/organisations/#{organisation.id}"
          }
        }
      )
    end
  end
end
