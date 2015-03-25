class RemovePermissionIdFields < ActiveRecord::Migration
  def change
    remove_column :roles, :permission_id
    remove_column :users, :permission_id
  end
end
