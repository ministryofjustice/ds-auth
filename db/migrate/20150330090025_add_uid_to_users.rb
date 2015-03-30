class AddUidToUsers < ActiveRecord::Migration
  def change
    add_column :users, :uid, :uuid, default: "uuid_generate_v4()"
  end
end
