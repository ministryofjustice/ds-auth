FactoryGirl.define do
  factory :profile do |profile|
    name                        { Faker::Name.name }
    address                     { Faker::Address.street_address }
    postcode                    "POSTCODE"
    sequence(:email)            { |n| "profile_#{n}@example.com" }
    tel                         "09011105010"
  end

  trait :with_user do
    association :user
  end
end
