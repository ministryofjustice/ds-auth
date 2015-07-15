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
    let!(:application) { create :doorkeeper_application, name: "test app", available_roles: %w(beastmaster) }

    it "serializes the credentials for the passed in user" do
      organisation = create :organisation
      application.organisations << organisation
      application.save!
      user = create :user
      membership = create :membership, user: user, organisation: organisation
      create :application_membership, application: application, membership: membership, roles: application.available_roles

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
            organisations: [
                {
                    uid: organisation.uid,
                    name: organisation.name,
                    roles: ["beastmaster"]
                }
            ],
            uid: user.uid
          }
        }
      )
    end
  end
end
