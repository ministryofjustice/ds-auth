class AddPhoneNumbersToProfilesOrganisations < ActiveRecord::Migration
  def change
    add_column :profiles, :mobile, :string
    add_column :organisations, :mobile, :string
  end
end
