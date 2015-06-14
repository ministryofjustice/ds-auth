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
      organisation = create :organisation
      user = create :user, organisations: [organisation]
      serializer = CredentialsSerializer.new user: user, application: application

      expect(serializer.serialize).to eq(
        {
          user: {
            email: user.email,
            name: user.name,
            telephone: user.telephone,
            mobile: user.mobile,
            address: {
              full_address: user.address,
              postcode: user.postcode,
            },
            organisation_uids: user.organisations.map(&:uid),
            uid: user.uid
          },
          roles: user.role_names_for(application: application)
        }
      )
    end
  end
end
