class RemoveMembershipApplicationsWithRoles < ActiveRecord::Migration
  def change
    remove_column :memberships, :applications_with_roles, :jsonb, default: '{}' # rubocop:disable Style/StringLiterals
  end
end
