class AddTimeStampsToGovernmentApplications < ActiveRecord::Migration
  def change
    add_timestamps(:government_applications, null: true)
  end
end
