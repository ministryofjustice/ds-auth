class AddKeys < ActiveRecord::Migration
  def change
    add_foreign_key :organisations, :organisations, column: :parent_organisation_id, name: :organisations_parent_organisation_id_fk
  end
end
