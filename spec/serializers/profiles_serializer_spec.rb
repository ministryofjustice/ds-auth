require "rails_helper"

RSpec.describe ProfilesSerializer do
  describe "#as_json" do
    subject { ProfilesSerializer.new profiles: double("Profiles") }

    it "calls serialize" do
      profiles_hash = double("profiles")
      opts = {}

      expect(subject).to receive(:serialize).and_return(profiles_hash)

      expect(subject.as_json(opts)).to eq(profiles_hash)
    end
  end

  describe "#serialize" do
    let(:organisation) { build_stubbed :organisation }
    let(:profile_1)    { build_stubbed :profile, organisations: [organisation] }
    let(:profile_2)    { build_stubbed :profile, organisations: [organisation] }

    it "serializes all profiles in the provided order" do
      serializer = ProfilesSerializer.new profiles: [profile_1, profile_2]

      expect(serializer.serialize).to eq(
        "profiles" => [
          {
            "uid" => profile_1.uid,
            "name" => profile_1.name,
            "links" => {
              "organisation" => "/api/v1/organisations/#{organisation.id}"
            }
          },
          {
            "uid" => profile_2.uid,
            "name" => profile_2.name,
            "links" => {
              "organisation" => "/api/v1/organisations/#{organisation.id}"
            }
          }
        ]
      )
    end
  end
end
