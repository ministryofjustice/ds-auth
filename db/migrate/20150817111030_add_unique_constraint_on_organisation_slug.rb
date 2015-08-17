class AddUniqueConstraintOnOrganisationSlug < ActiveRecord::Migration
  def change
    change_column :organisations, :slug, :string, null: false, unique: true
  end
end
