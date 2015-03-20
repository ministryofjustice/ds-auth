class CreatePermissions < ActiveRecord::Migration
  def change
    create_table :permissions do |t|
      t.integer :role_id
      t.integer :user_id
      t.integer :organisation_id
      t.integer :government_application_id
    end
  end
end
