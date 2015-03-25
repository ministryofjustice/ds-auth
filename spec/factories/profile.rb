FactoryGirl.define do
  factory :profile do |profile|
    name                        "Barry Evans"
    address                     "742 Evergreen terrace"
    postcode                    "POSTCODE"
    sequence(:email)            { |n| "barry#{n}@example.com" }
    tel                         "09011105010"
  end

  trait :with_user do
    association :user
  end
end
