FactoryGirl.define do
  factory :application_membership do
    application { doorkeeper_application }
    membership
    roles []
    can_login false
  end
end
