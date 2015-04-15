require "rails_helper"

RSpec.describe ProfileSerializer do
  describe "#as_json" do
    subject { ProfileSerializer.new profile: double("Profile") }

    it "calls serialize" do
      profile_hash = double("profile_hash")
      opts = {}

      expect(subject).to receive(:serialize).and_return(profile_hash)

      expect(subject.as_json(opts)).to eq(profile_hash)
    end
  end

  describe "#serialize" do
    let(:organisation) { build_stubbed :organisation }
    let(:profile) { build_stubbed :profile, organisations: [organisation] }

    it "serializes the profile" do
      serializer = ProfileSerializer.new profile: profile

      expect(serializer.serialize).to eq(
        {
          "profile" => {
            "uid" => profile.uid,
            "name" => profile.name,
            "links" => {
              "organisation" => "/api/v1/organisations/#{organisation.id}"
            }
          }
        }
      )
    end
  end
end
