class CreateGovernmentApplication < ActiveRecord::Migration
  def change
    create_table :government_applications do |t|
      t.integer :permission_id
      t.string :oauth_application_id
    end
  end
end


