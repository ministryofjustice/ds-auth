class AddIsWebOpsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :is_webops, :boolean, null: :false, default: false
  end
end
