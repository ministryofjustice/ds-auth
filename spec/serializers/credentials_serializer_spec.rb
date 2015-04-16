require "rails_helper"

RSpec.describe CredentialsSerializer do
  describe "#as_json" do
    subject { CredentialsSerializer.new user: double("User"), application: double("Application") }

    it "calls serialize" do
      credentials_hash = double("credentials")
      opts = {}

      expect(subject).to receive(:serialize).and_return(credentials_hash)

      expect(subject.as_json(opts)).to eq(credentials_hash)
    end
  end

  describe "#serialize" do
    let(:profile) { create :profile, :with_organisations }
    let(:application) { build_stubbed :doorkeeper_application }
    let(:role) { build_stubbed :role }
    let(:permission) { build_stubbed :permission, application: application, user: user, role: role }

    it "serializes the credentials for the passed in user" do
      user = build_stubbed :user, profile: profile
      serializer = CredentialsSerializer.new user: user, application: application

      expect(serializer.serialize).to eq(
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
            organisation_uids: user.profile.organisations.map(&:uid),
            uid: user.profile.uid
          },
          roles: user.roles_for(application: application).map(&:name)
        }
      )
    end

    it "returns empty profile keys if the user has no profile" do
      user = build_stubbed :user
      serializer = CredentialsSerializer.new user: user, application: application

      expect(serializer.serialize).to eq(
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
            organisation_uids: [],
            uid: ""
          },
          roles: []
        }
      )
    end
  end
end
