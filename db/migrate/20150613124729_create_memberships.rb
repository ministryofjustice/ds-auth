class CreateMemberships < ActiveRecord::Migration
  def change
    create_table :memberships do |t|
      t.references :organisation, index: true, foreign_key: true
      t.references :user, index: true, foreign_key: true
      t.jsonb :permissions, default: {}

      t.timestamps null: false
    end
  end
end
