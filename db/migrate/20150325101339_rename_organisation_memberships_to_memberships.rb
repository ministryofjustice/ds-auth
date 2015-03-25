class RenameOrganisationMembershipsToMemberships < ActiveRecord::Migration
  def change
    rename_table :organisation_memberships, :memberships
  end
end
