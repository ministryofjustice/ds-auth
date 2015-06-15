class UniqueOrganisationsForUsers < ActiveRecord::Migration
  def change
    add_index :memberships, [:organisation_id, :user_id], unique: true
  end
end
