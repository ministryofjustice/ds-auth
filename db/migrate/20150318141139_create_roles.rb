class CreateRoles < ActiveRecord::Migration
  def change
    create_table :roles do |t|
      t.string  :name,                 null: false, default: ""
      t.integer :organisation_id
      t.string  :oauth_application_id
      t.integer :permission_id
    end
  end
end
