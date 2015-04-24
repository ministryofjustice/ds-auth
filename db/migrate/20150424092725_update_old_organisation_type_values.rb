class UpdateOldOrganisationTypeValues < ActiveRecord::Migration
  def up
    organisations_to_update = Organisation.where.not(organisation_type: Organisation::ORGANISATION_TYPES.values)
    organisations_to_update.each do |o|
      o.update_attribute(:organisation_type, "custody_suite")
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
