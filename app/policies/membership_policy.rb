class MembershipPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.none
    end
  end

  def show?
    false
  end

  def create?
    user_is_webops || user_is_admin_in_organisation
  end

  alias :update? :create?
  alias :destroy? :create?

  private

  def user_is_admin_in_organisation
    user.memberships.where(organisation: record.organisation).with_any_role("admin").exists?
  end
end
