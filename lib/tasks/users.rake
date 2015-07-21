namespace :users do
  desc "Create an admin user with the provided attributes"
  task create_webops: :environment do
    CreateUserWithoutMembership.new(ENV).call
  end
end
