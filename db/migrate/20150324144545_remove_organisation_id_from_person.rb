class RemoveOrganisationIdFromPerson < ActiveRecord::Migration
  def change
    remove_column :people, :organisation_id
  end
end
