class AddDetailsToOrganisations < ActiveRecord::Migration
  def change
    add_column :organisations, :details, :jsonb, default: "{}"
    add_index :organisations, :details, using: :gin
  end
end
