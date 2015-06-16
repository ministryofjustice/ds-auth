FactoryGirl.define do
  factory :organisation do
    name              { Faker::Company.name }
    slug              { Faker::Internet.slug name}
    organisation_type "custody_suite"
    tel               { Faker::PhoneNumber.phone_number }
    searchable         true
    uid                { SecureRandom.uuid }

    trait :with_users do
      transient do
        user_count 0
      end

      after(:create) do |organisation, evaluator|
        FactoryGirl.build_list(:membership, evaluator.user_count, organisation: organisation)
      end
    end
  end
end
