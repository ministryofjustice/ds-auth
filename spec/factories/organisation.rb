
FactoryGirl.define do
  factory :organisation do |organisation|
    organisation.name              'NAMBLA'
    organisation.slug              'north-american-marlon-brando-lookalikes'
    organisation.organisation_type 'social'
    organisation.searchable         true
  end
end
