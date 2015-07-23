FactoryGirl.define do
  factory :doorkeeper_application, class: "Doorkeeper::Application" do |application|
    sequence(:name) {|i| "#{Faker::App.name}#{i}" }
    sequence(:uid) {|i| "#{i}" }
    sequence(:secret) {|i| "#{i}" }
    redirect_uri "https://example.com/oauth/callbacks"
    handles_own_authorization false
    available_roles ["viewer"]
  end
end
