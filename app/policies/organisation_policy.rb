class OrganisationPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.is_webops?
        scope.all
      else
        scope.joins(:memberships).where(memberships: { user: user })
      end
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
    user_belongs_to_organisation || user_is_webops
  end

  def create?
    user_is_webops
  end

  def update?
    user_is_admin_in_organisation || user_is_webops
  end

  alias :destroy? :create?

  # Can the user create a user for this Organisation
  def manage_members?
    user_is_admin_in_organisation || user_is_webops
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

  def user_is_webops
    user.is_webops?
  end
end
