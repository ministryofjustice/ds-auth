class AddTimeStampsToPermissions < ActiveRecord::Migration
  def change
    add_timestamps(:permissions, null: true)
  end
end
