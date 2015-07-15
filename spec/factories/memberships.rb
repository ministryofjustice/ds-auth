FactoryGirl.define do
  factory :membership do
    organisation
    user
    is_organisation_admin false
  end
end
