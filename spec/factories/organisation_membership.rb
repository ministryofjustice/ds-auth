FactoryGirl.define do
  factory :organisation_membership do
    association :organisation
    association :person
  end
end
