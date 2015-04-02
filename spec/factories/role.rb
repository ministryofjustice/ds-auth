FactoryGirl.define do
  factory :role do |role|
    name { Faker::Role.name }
  end
end
