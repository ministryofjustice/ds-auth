require "rails_helper"

RSpec.describe ApplicationPolicy do
  let(:organisation) { FactoryGirl.build :organisation }
  let(:user) { FactoryGirl.build :user }

  subject { ApplicationPolicy.new user, organisation }

  it { is_expected.not_to permit_action(:index) }
  it { is_expected.not_to permit_action(:show) }
  it { is_expected.not_to permit_action(:edit) }
  it { is_expected.not_to permit_action(:update) }
  it { is_expected.not_to permit_action(:new) }
  it { is_expected.not_to permit_action(:create) }
  it { is_expected.not_to permit_action(:destroy) }

end
