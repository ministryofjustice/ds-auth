FactoryGirl.define do
  factory :role do |role|
    name { Faker::Internet.slug(FFaker::Job.title) }
  end
end
