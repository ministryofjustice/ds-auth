require "rails_helper"

RSpec.describe CredentialsSerializer do

  describe "#as_json" do
    let(:profile) { build_stubbed :profile }
    let(:application) { build_stubbed :doorkeeper_application }
    let(:role) { build_stubbed :role }
    let(:permission) { build_stubbed :permission, application: application, user: user, role: role }

    it "serializes the credentials for the passed in user" do
      user = build_stubbed :user, profile: profile
      serializer = CredentialsSerializer.new user: user, application: application

      expect(serializer.as_json).to eq(
        {
          user: {
            email: user.email,
          },
          profile: {
            email: user.profile.email,
            name: user.profile.name,
            telephone: user.profile.tel,
            mobile: user.profile.mobile,
            address: {
              full_address: user.profile.address,
              postcode: user.profile.postcode,
            },
            organisation_ids: user.profile.organisations.map(&:id),
            uid: user.profile.uid
          },
          roles: user.roles_for(application: application).map(&:name)
        }
      )
    end

    it "returns empty profile keys if the user has no profile" do
      user = build_stubbed :user
      serializer = CredentialsSerializer.new user: user, application: application

      expect(serializer.as_json).to eq(
        {
          user: {
            email: user.email,
          },
          profile: {
            email: "",
            name: "",
            telephone: "",
            mobile: "",
            address: {
              full_address: "",
              postcode: "",
            },
            organisation_ids: [],
            uid: ""
          },
          roles: []
        }
      )
    end
  end

end
