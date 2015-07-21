class CreateApplicationsOrganisations < ActiveRecord::Migration
  def change
    create_table :applications_organisations, id: false do |t|
      t.references :oauth_application, index: true, foreign_key: true
      t.references :organisation, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
