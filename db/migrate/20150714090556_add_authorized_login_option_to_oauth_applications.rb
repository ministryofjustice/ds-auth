class AddAuthorizedLoginOptionToOauthApplications < ActiveRecord::Migration
  def change
    add_column :oauth_applications, :only_allow_authorized_login, :boolean, default: true
  end
end
