class AddTimeStampsToMemberships < ActiveRecord::Migration
  def change
    add_timestamps(:memberships, null: true)
  end
end
