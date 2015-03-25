class CreateRoles < ActiveRecord::Migration
  def change
    create_table :roles do |t|
      t.string  :name,                 null: false, default: ""
      t.integer :permission_id
    end
  end
end
