require "rails_helper"

RSpec.describe CredentialsSerializer, "#call" do
  it "serializes the credentials for the passed in user" do
    profile = build_stubbed :profile
    user = build_stubbed :user, profile: profile

    serializer = CredentialsSerializer.new user

    expect(serializer.call).to eq(
      {
        "user" => {
          id: user.id,
          email: user.email,
          uid: user.uid
        },
        "profile" => {
          "email" => user.profile.email,
          "name" => user.profile.name,
          "telephone" => user.profile.tel,
          "address" => {
            full_address: user.profile.address,
            postcode: user.profile.postcode,
          },
          "organisation_ids" => user.profile.organisations.map(&:id)
        },
        "roles" => user.roles.pluck(:name)
      }.to_json
    )
  end

  it "returns empty profile keys if the user has no profile" do
    user = build_stubbed :user

    serializer = CredentialsSerializer.new user

    expect(serializer.call).to eq(
      {
        "user" => {
          id: user.id,
          email: user.email,
          uid: user.uid
        },
        "profile" => {
          "email" => "",
          "name" => "",
          "telephone" => "",
          "address" => {
            "full_address" => "",
            "postcode" => "",
          },
          "organisation_ids" => [],
        },
        "roles" => []
      }.to_json
    )
  end
end
