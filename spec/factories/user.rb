FactoryGirl.define do
  factory :user do |user|
    sequence(:email)            {|n| "barry#{n}@example.com" }
    user.password               "password"
    user.password_confirmation  "password"
    user.uid { SecureRandom.uuid }

    trait :with_profile do
      association :profile
    end
  end
end
