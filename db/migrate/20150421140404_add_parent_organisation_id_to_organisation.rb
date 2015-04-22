class AddParentOrganisationIdToOrganisation < ActiveRecord::Migration
  def change
    add_reference :organisations, :parent_organisation, index: true
  end
end
