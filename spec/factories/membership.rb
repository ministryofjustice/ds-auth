FactoryGirl.define do
  factory :membership do
    association :organisation
    association :profile
  end
end
