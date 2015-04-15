require "rails_helper"

RSpec.describe ProfilesSerializer do
  describe "#as_json" do
    let(:organisation) { build_stubbed :organisation }
    let(:profile_1)    { build_stubbed :profile, organisations: [organisation] }
    let(:profile_2)    { build_stubbed :profile, organisations: [organisation] }

    it "serializes all profiles in the provided order" do
      serializer = ProfilesSerializer.new profiles: [profile_1, profile_2]

      expect(serializer.as_json).to eq(
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
