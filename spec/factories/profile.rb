FactoryGirl.define do
  factory :profile do |profile|
    name                        { Faker::Name.name }
    address                     { Faker::Address.street_address }
    postcode                    "POSTCODE"
    sequence(:email)            { |n| "profile_#{n}@example.com" }
    tel                         "01632 960178"
    mobile                      "07700 900407"
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
