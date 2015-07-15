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
    user_is_webops || user_is_organisation_admin
  end

  alias :update? :create?
  alias :destroy? :create?

  private

  def user_is_organisation_admin
    user.memberships.where(organisation: record.organisation, is_organisation_admin: true).exists?
  end
end
