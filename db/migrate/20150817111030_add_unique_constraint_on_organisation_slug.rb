class AddUniqueConstraintOnOrganisationSlug < ActiveRecord::Migration
  def change
    add_index :organisations, :slug, unique: true
  end
end
