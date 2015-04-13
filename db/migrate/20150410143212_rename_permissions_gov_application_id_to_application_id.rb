class RenamePermissionsGovApplicationIdToApplicationId < ActiveRecord::Migration
  def change
    rename_column :permissions, :government_application_id, :application_id
  end
end
