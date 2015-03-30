class AddTimeStampsToProfiles < ActiveRecord::Migration
  def change
    add_timestamps(:profiles, null: true)
  end
end
