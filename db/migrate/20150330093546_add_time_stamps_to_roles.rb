class AddTimeStampsToRoles < ActiveRecord::Migration
  def change
    add_timestamps(:roles, null: true)
  end
end
