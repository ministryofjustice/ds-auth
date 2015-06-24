class OrganisationPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.joins(:memberships).where(memberships: { user: user })
    end
  end

  def permitted_attributes
    if record.new_record?
      default_permitted_attributes + [:slug, :organisation_type, :parent_organisation_id]
    else
      default_permitted_attributes
    end
  end

  def show?
    user_belongs_to_organisation
  end

  def create?
    false
  end

  def update?
    user_is_admin_in_organisation
  end

  alias :destroy? :create?

  # Can the user create a user for this Organisation
  def manage_members?
    user_is_admin_in_organisation
  end

  private

  def default_permitted_attributes
    [:name,
    :searchable,
    :tel,
    :mobile,
    :address,
    :postcode,
    :email,
    :supplier_number]
  end

  def user_belongs_to_organisation
    record.memberships.where(user: user).exists?
  end

  def user_is_admin_in_organisation
    record.memberships.where(user: user).with_any_role("admin").exists?
  end
end
