FactoryGirl.define do
  factory :profile do |profile|
    name                        { Faker::Name.name }
    address                     { Faker::Address.street_address }
    postcode                    Faker::Address.postcode
    sequence(:email)            { |n| "profile_#{n}@example.com" }
    tel                         "0207" + Faker::Number.number(7)
    mobile                      "07" + Faker::Number.number(9)
    uid                         { SecureRandom.uuid }
  end

  trait :with_organisations do
    transient do
      number_of_organisations 2
    end

    after(:create) do |profile, evaluator|
      (1..evaluator.number_of_organisations).each do
        create :membership, profile: profile
      end
    end
  end

  trait :with_user do
    association :user
  end
end
