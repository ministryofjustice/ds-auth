FactoryGirl.define do
  factory :permission do |role|
    association :user
    association :organisation
    association :role
    association :application, factory: :doorkeeper_application
  end
end
