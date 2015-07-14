class RenameOnlyAllowAuthorizedLoginOnDoorkeeperApplication < ActiveRecord::Migration
  def up
    rename_column :oauth_applications, :only_allow_authorized_login, :handles_own_authorization
    change_column :oauth_applications, :handles_own_authorization, :boolean, default: false
  end

  def down
    rename_column :oauth_applications, :handles_own_authorization, :only_allow_authorized_login
    change_column :oauth_applications, :only_allow_authorized_login, :boolean, default: true
  end
end
