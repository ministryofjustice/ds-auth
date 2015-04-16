class AddIndexOnUidOnProfiles < ActiveRecord::Migration
  def change
    add_index :profiles, :uid
  end
end
