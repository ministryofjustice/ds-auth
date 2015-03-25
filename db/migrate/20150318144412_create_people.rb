class CreatePeople < ActiveRecord::Migration
  def change
    create_table :people do |t|
      t.integer :organisation_id
      t.integer :user_id

      t.string  :name, null: false
      t.string  :tel
      t.text    :address
      t.string  :postcode
      t.string  :email
    end
  end
end
