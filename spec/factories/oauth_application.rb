FactoryGirl.define do
  factory :oauth_application, class: Doorkeeper::Application do |application|
    name          { Faker::App.name }
    uid           { ('a'..'z').to_a.shuffle.join }
    secret        { ('a'..'z').to_a.shuffle.join }
    redirect_uri  { Faker::Internet.url('example.com').gsub(/http/, 'https') }
  end
end
