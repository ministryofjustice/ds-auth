class CreateOrganisationMemberships < ActiveRecord::Migration
  def change
    create_table :organisation_memberships do |t|
      t.integer :person_id
      t.integer :organisation_id
    end
  end
end
