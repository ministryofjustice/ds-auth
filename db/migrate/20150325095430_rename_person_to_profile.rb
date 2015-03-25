class RenamePersonToProfile < ActiveRecord::Migration
  def change
    rename_table :people, :profiles

    rename_column :organisation_memberships, :person_id, :profile_id
  end
end
