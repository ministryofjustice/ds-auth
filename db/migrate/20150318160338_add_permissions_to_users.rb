class AddPermissionsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :permission_id, :integer
  end
end
