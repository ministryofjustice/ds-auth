FactoryGirl.define do
  factory :user do |user|
    name                        { Faker::Name.name }
    address                     { Faker::Address.street_address }
    postcode                    Faker::Address.postcode
    sequence(:email)            { |n| n.to_s + Faker::Internet.email }
    telephone                   "0207" + Faker::Number.number(7)
    mobile                      "07" + Faker::Number.number(9)
    uid                         { SecureRandom.uuid }
    password                    Faker::Internet.password(8)
    password_confirmation       { password }

    trait :with_organisations do
      transient do
        number_of_organisations 2
      end

      after(:create) do |u, evaluator|
        (1..evaluator.number_of_organisations).each do
          create :membership, user: u, organisation: create(:organisation)
        end
      end
    end

    trait :logged_in_to_applications do
      transient do
        number_of_applications 2
      end

      after(:create) do |u, evaluator|
        (1..evaluator.number_of_applications).each do
          application = create :doorkeeper_application
          create :access_token, application: application, resource_owner_id: u.id
        end
      end
    end
  end
end
