class MoveUidFromUsersToProfiles < ActiveRecord::Migration
  def change
    remove_column :users, :uid, :uuid, default: "uuid_generate_v4()"
    add_column :profiles, :uid, :uuid, default: "uuid_generate_v4()"
  end
end
