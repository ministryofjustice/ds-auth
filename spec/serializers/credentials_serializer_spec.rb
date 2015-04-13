require "rails_helper"

RSpec.describe CredentialsSerializer do

  describe "#to_json" do
    subject { CredentialsSerializer.new user: double("User"), application: double("Application") }

    it "calls to_json with options on the serialized response" do
      serialized_credentials_as_json = double("JsonizedCredentials")
      serialized_credentials = double("Credentials")
      opts = {}

      expect(serialized_credentials).to receive(:to_json).with(opts).and_return serialized_credentials_as_json
      expect(subject).to receive(:serialize).and_return serialized_credentials
      
      expect(subject.to_json(opts)).to eq(serialized_credentials_as_json)
    end
  end

  describe "#serialize" do
    let(:profile) { build_stubbed :profile }
    let(:application) { build_stubbed :doorkeeper_application }
    let(:role) { build_stubbed :role }
    let(:permission) { build_stubbed :permission, application: application, user: user, role: role }

    it "serializes the credentials for the passed in user" do
      user = build_stubbed :user, profile: profile
      serializer = CredentialsSerializer.new user: user, application: application

      expect(serializer.serialize).to eq(
        {
          user: {
            id: user.id,
            email: user.email,
            uid: user.uid
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
            organisation_ids: user.profile.organisations.map(&:id)
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
            id: user.id,
            email: user.email,
            uid: user.uid
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
          },
          roles: []
        }
      )
    end
  end

  
end
