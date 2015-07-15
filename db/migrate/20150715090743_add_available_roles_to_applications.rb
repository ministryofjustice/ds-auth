class AddAvailableRolesToApplications < ActiveRecord::Migration
  def change
    add_column :oauth_applications, :available_roles, :string, array: true, default: []
  end
end
