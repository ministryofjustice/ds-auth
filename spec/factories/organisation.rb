FactoryGirl.define do
  factory :organisation do |organisation|
    organisation.name              'NAMBLA'
    organisation.slug              'north-american-marlon-brando-lookalikes'
    organisation.organisation_type 'social'
    organisation.searchable         true

    trait :with_profiles_and_users do
      transient do
        profile_count 0
      end

      after(:create) do |organisation, evaluator|
        memberships = FactoryGirl.build_list(:membership, evaluator.profile_count, organisation: organisation)
        memberships.each do |membership|
          FactoryGirl.create(:profile, :with_user, memberships: [membership])
          membership.save
        end
      end
    end
  end
end
