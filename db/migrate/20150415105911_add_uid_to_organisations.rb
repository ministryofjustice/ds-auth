class AddUidToOrganisations < ActiveRecord::Migration
  def change
    add_column :organisations, :uid, :uuid, default: "uuid_generate_v4()"
  end
end
