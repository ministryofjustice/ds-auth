FactoryGirl.define do
  factory :permission do |role|
    association :user
    association :role
    association :application, factory: :oauth_application

    trait :with_organisation do
      association :organisation
    end
  end
end
