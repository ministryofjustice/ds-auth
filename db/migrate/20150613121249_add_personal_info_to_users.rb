class AddPersonalInfoToUsers < ActiveRecord::Migration
  def change
    add_column :users, :name, :string, null: false
    add_column :users, :telephone, :string
    add_column :users, :mobile, :string
    add_column :users, :address, :string
    add_column :users, :postcode, :string
    add_column :users, :uid, :uuid, default: "uuid_generate_v4()"
  end
end
