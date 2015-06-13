class RemoveOldSchema < ActiveRecord::Migration
  def up
    drop_table :permissions
    drop_table :memberships
    drop_table :profiles
    drop_table :roles
    drop_table :government_applications
  end

  def down
    raise ActiveRecord::IrreversibleMigration, "Cannot revert to old schema"
  end
end
