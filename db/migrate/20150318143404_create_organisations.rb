class CreateOrganisations < ActiveRecord::Migration
  def change
    create_table :organisations do |t|
      t.string  :slug, null: false
      t.string  :name, null: false
      t.string  :organisation_type, null: false
      t.boolean :searchable, null: false
      t.string  :tel
      t.text    :address
      t.string  :postcode
      t.string  :email
    end
  end
end
