require "rails_helper"

RSpec.describe ProfileSerializer do
  describe "#as_json" do
    let(:organisation) { build_stubbed :organisation }
    let(:profile) { build_stubbed :profile, organisations: [organisation] }

    it "serializes the profile" do
      serializer = ProfileSerializer.new profile: profile

      expect(serializer.as_json).to eq(
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
