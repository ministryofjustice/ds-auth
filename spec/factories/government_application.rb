FactoryGirl.define do
  factory :government_application do |application|
    association :oauth_application
  end
end
