require "rails_helper"

RSpec.describe Role do
  let(:user){ create :user }

  describe "initializing" do
    it "accepts name and application params" do
      role = Role.new name: "foo", applications: ["bar"]

      expect(role.name).to eq("foo")
      expect(role.application).to eq(["bar"])
    end
  end

  describe "sorting" do
    it "can be sorted by name with other Roles" do
      role1 = Role.new name: "foo"
      role2 = Role.new name: "bar"

      expect([role1, role2].sort).to eq([role2, role1])
    end
  end
end
