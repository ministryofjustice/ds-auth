FactoryGirl.define do
  factory :permission do |role|
    association :user
    association :organisation
    association :role
    association :government_application
  end
end
