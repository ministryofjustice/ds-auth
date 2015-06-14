class UserPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.joins(:memberships).where(memberships: { organisation: user.organisations })
    end
  end

  def show?
    is_user || user_belongs_to_same_organisation
  end

  def create?
    user_is_admin
  end

  def update?
    is_user || user_is_admin_in_profile_organisation
  end

  alias :destroy? :create?

  private

  def is_user
    user.id == record.id
  end

  def user_belongs_to_same_organisation
    (user.organisation_ids & record.organisation_ids).length > 0
  end

  def user_is_admin_in_profile_organisation
    user_belongs_to_same_organisation &&
    user.memberships.where(organisation: record.organisations).with_any_role("admin").exists?
  end

  def user_is_admin
    user.memberships.with_any_role("admin").exists?
  end
end
