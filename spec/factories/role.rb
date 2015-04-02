FactoryGirl.define do
  factory :role do |role|
    sequence(:name) { |n| "#{Faker::Role.name}-#{n}"  }
  end
end
