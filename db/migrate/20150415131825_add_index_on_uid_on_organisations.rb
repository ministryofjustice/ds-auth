class AddIndexOnUidOnOrganisations < ActiveRecord::Migration
  def change
    add_index :organisations, :uid
  end
end
