FactoryGirl.define do
  factory :organisation do |organisation|
    organisation.name              'NAMBLA'
    organisation.slug              'north-american-marlon-brando-lookalikes'
    organisation.organisation_type 'social'
    organisation.searchable         true

    trait :with_people_and_users do
      transient do
        people_count 0
      end

      after(:create) do |organisation, evaluator|
        organisation_memberships = FactoryGirl.build_list(:organisation_membership, evaluator.people_count, organisation: organisation)
        organisation_memberships.each do |membership|
          FactoryGirl.create(:person, :with_user, organisation_memberships: [membership])
          membership.save
        end
      end
    end
  end
end
