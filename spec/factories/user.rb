FactoryGirl.define do
  factory :user do |user|
    sequence(:email)            {|n| "barry#{n}@example.com" }
    user.password               Faker::Internet.password(8)
    user.password_confirmation  { password }

    trait :with_profile do
      association :profile
    end

    trait :logged_in_to_applications do
      transient do
        number_of_applications 2
      end

      after(:create) do |user, evaluator|
        (1..evaluator.number_of_applications).each do
          application = create :oauth_application
          create :permission, application: application, user: user
          create :access_token, application: application, resource_owner_id: user.id
        end
      end
    end
  end
end
