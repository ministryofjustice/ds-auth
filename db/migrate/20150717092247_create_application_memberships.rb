class CreateApplicationMemberships < ActiveRecord::Migration
  def change
    create_table :application_memberships do |t|
      t.integer :application_id, index: true
      t.references :membership, index: true, foreign_key: true
      t.string :roles, array: true, default: []
      t.boolean :can_login, default: false, null: false

      t.timestamps null: false
    end

    add_foreign_key :application_memberships, :oauth_applications, column: :application_id
  end
end
