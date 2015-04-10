require 'rails_helper'

RSpec.describe User do
  let(:user){ create :user }
  let(:role) { Role.create(name: 'super-danger-admin') }

  describe 'associations' do
    specify { expect(subject).to have_one(:profile) }
    specify { expect(subject).to have_many(:permissions) }
  end

  describe "#permissions.for_application" do
    let!(:application) { create :doorkeeper_application }
    let!(:application2) { create :doorkeeper_application }
    let!(:role) { create :role }

    let!(:permission1) { create :permission, application: application, role: role, user: user }
    let!(:permission2) { create :permission, application: application2, role: role, user: user }

    it "returns an ActiveRecord::Relation" do
      expect(user.permissions.for_application(application).class.ancestors).to include(ActiveRecord::AssociationRelation)
    end

    it "returns permissions only for the given application" do
      expect(user.permissions.for_application(application)).to eq([permission1])
    end
  end

  describe "#roles_for" do
    let(:application) { build :doorkeeper_application }
    let(:role) { build :role }

    it "raises an error without an application" do
      expect { subject.roles_for }.to raise_error(ArgumentError)
    end

    it "returns an empty array when user has no roles for the given application" do
      expect(subject.roles_for(application: application)).to eq([])
    end

    it "returns the roles a user has for the given application" do
      expect(subject.permissions).to receive(:for_application).with(application).and_return [double("Permission", role: role)]
      expect(subject.roles_for(application: application)).to eq([role])
    end
  end
end
