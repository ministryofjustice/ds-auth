namespace :users do
  desc "Create an admin user with the provided attributes"
  task create_webops: :environment do
    CreateUserWithoutMembership.new(
      extract_user_parameters(ENV)
    ).call
  end

  def extract_user_parameters(hash)
    hash.slice("name", "email", "password")
  end
end
