class AddOrganisationAdminFlagToMemberships < ActiveRecord::Migration
  def change
    add_column :memberships, :is_organisation_admin, :boolean, null: false, default: false
  end
end
