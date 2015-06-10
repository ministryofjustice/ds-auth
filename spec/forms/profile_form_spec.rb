require "rails_helper"

RSpec.describe ProfileForm do
  subject { ProfileForm.new profile: profile, user: user }
  let(:profile) { FactoryGirl.build :profile }
  let(:user) { FactoryGirl.build :user }

  describe "validations" do
    [:name, :address, :postcode, :email].each do |field|
      it { expect(subject).to validate_presence_of field }
    end

    # Reform wraps the ActiveRecord::UniquenessValidator in its own module so check for that
    # TODO: move this into a custom rspec matcher
    specify { expect(subject.class._validators[:email].find {|v| v.is_a? Reform::Form::ActiveRecord::UniquenessValidator }).not_to be_nil }

    specify { expect(subject).to allow_value("email@example.com").for(:email) }
    specify { expect(subject).to_not allow_value("email@example").for(:email) }
    specify { expect(subject).to_not allow_value("email-example.com").for(:email) }
    specify { expect(subject).to_not allow_value("hello***@example.com").for(:email) }
  end
end
