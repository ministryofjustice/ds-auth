require "rails_helper"

RSpec.describe UserSerializer do
  describe "#serialize" do
    let(:organisation) { build_stubbed :organisation }
    let(:user) { build_stubbed :user, organisations: [organisation] }

    it "serializes the user" do
      serializer = UserSerializer.new user

      expect(serializer.serialize).to eq(
        {
          uid: user.uid,
          name: user.name,
          links: {
            organisation: "/api/v1/organisations/#{organisation.uid}"
          }
        }
      )
    end
  end
end
