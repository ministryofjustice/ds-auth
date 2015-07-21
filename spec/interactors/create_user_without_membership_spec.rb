require "rails_helper"

RSpec.describe CreateUserWithoutMembership, "#call" do
  it "creates a webops user with the attributes provided" do
    attrs = {
      "name" => "Test User",
      "email" => "test.user@webops.example",
      "password" => "password"
    }

    CreateUserWithoutMembership.new(attrs).call

    expect(User.count).to eq 1
    expect(User.last.name).to eq "Test User"
    expect(User.last.email).to eq "test.user@webops.example"
    expect(User.last).to be_is_webops
  end

  it "raises an error if any of the attributes are not provided" do
    attrs = {
      "name" => "Test User",
      "password" => "password"
    }

    expect { CreateUserWithoutMembership.new(attrs).call }.to raise_error(/Requires name, email, and password/)
  end
end
