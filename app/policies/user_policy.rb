class UserPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.is_webops?
        scope.includes(memberships: [ :organisation ]).all
      else
        scope.
        uniq.
        joins(:memberships).
        where(memberships: { organisation: user.organisations }).
        includes(memberships: [ :organisation ])
      end
    end
  end

  def permitted_attributes
    [:email, :password, :password_confirmation, :name, :telephone, :mobile, :address, :postcode, :email]
  end

  def show?
    is_user || user_belongs_to_same_organisation || user_is_webops
  end

  def create?
    user_is_organisation_admin || user_is_webops
  end

  def update?
    is_user || user_is_organisation_admin || user_is_webops
  end

  alias :destroy? :create?

  private

  def is_user
    user.id == record.id
  end

  def user_belongs_to_same_organisation
    (user.organisation_ids & record.organisation_ids).length > 0
  end

  def user_is_organisation_admin
    user.memberships.where(organisation: record.memberships.map(&:organisation), is_organisation_admin: true).exists?
  end
end
