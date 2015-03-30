class RemovePermissionIdFromGovernmentApplication < ActiveRecord::Migration
  def change
    remove_column :government_applications, :permission_id, :integer
  end
end
