class ChangeDefaultOrganisationSearchable < ActiveRecord::Migration
  def change
    change_column_default :organisations, :searchable, false
  end
end
