FactoryGirl.define do
  factory :role do |role|
    sequence(:name) { |n| Faker::Role.by_index n }
  end
end
