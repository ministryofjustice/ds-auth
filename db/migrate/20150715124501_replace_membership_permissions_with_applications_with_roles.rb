class ReplaceMembershipPermissionsWithApplicationsWithRoles < ActiveRecord::Migration
  def change
    remove_column :memberships, :permissions, :jsonb, default: '{}'  # rubocop:disable Style/StringLiterals
    add_column :memberships, :applications_with_roles, :jsonb, default: '{}' # rubocop:disable Style/StringLiterals
  end
end
