FactoryGirl.define do
  factory :user do |user|
    sequence(:email)            {|n| "barry#{n}@example.com" }
    user.password               "password"
    user.password_confirmation  "password"

    trait :with_person do
      association :person, factory: person
    end
  end
end
