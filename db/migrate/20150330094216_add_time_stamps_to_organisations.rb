class AddTimeStampsToOrganisations < ActiveRecord::Migration
  def change
    add_timestamps(:organisations, null: true)
  end
end
