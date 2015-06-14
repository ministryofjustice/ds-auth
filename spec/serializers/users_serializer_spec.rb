require "rails_helper"

RSpec.describe UsersSerializer do
  describe "#serialize" do
    let(:organisation) { build_stubbed :organisation }
    let(:user_1)    { build_stubbed :user, organisations: [organisation] }
    let(:user_2)    { build_stubbed :user, organisations: [organisation] }

    it "serializes all users in the provided order" do
      serializer = UsersSerializer.new [user_1, user_2]

      expect(serializer.serialize).to eq(
        [
          {
            uid: user_1.uid,
            name: user_1.name,
            links: {
              organisation: "/api/v1/organisations/#{organisation.uid}"
            }
          },
          {
            uid: user_2.uid,
            name: user_2.name,
            links: {
              organisation: "/api/v1/organisations/#{organisation.uid}"
            }
          }
        ]
      )
    end
  end
end
