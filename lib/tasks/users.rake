namespace :users do
  desc "Create an admin user with the provided attributes"
  task create_webops: :environment do
    CreateUserWithoutMembership.new(
      extract_user_parameters
    ).call
  end

  def extract_user_parameters
    {
      name:     ENV["name"],
      email:    ENV["email"],
      password: ENV["password"]
    }
  end
end
