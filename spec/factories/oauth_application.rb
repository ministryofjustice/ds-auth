FactoryGirl.define do
  factory :oauth_application, class: Doorkeeper::Application do |application|
    sequence(:name) { |n| Faker::App.translate("faker.app.name")[n] }
    uid             { ("a".."z").to_a.shuffle.join }
    secret          { ("a".."z").to_a.shuffle.join }
    redirect_uri    { Faker::Internet.url("example.com").gsub(/http/, "https") }
  end
end
