FactoryGirl.define do
  factory :doorkeeper_application, class: "Doorkeeper::Application" do |application|
    sequence(:name) {|i| "Doorkeeper Application ##{i}" }
    sequence(:uid) {|i| "#{i}" }
    sequence(:secret) {|i| "#{i}" }
    redirect_uri "https://example.com/oauth/callbacks"
  end
end
