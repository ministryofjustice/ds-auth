class RemovePermissionIdFields < ActiveRecord::Migration
  def change
    remove_column :roles, :permission_id, :integer
    remove_column :users, :permission_id, :integer
  end
end
