FactoryGirl.define do
  factory :profile do |profile|
    name                        { Faker::Name.name }
    address                     { Faker::Address.street_address }
    postcode                    "POSTCODE"
    sequence(:email)            { |n| "profile_#{n}@example.com" }
    tel                         "01632 960178"
    mobile                      "07700 900407"
  end

  trait :with_user do
    association :user
  end
end
