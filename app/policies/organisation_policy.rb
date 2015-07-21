class OrganisationPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.is_webops?
        scope.all
      else
        scope.uniq.joins(:memberships).where(memberships: { user: user })
      end
    end
  end

  def permitted_attributes
    atts = default_permitted_attributes.dup
    atts = atts + [:slug, :parent_organisation_id]  if record.new_record?
    atts = atts + [application_ids: []]             if user.is_webops?
    atts
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

  # Can the user create/update a user for this Organisation
  def manage_members?
    user_is_admin_in_organisation || user_is_webops
  end

  private

  def default_permitted_attributes
    [:name,
     :tel,
     :mobile,
     :address,
     :postcode,
     :email]
  end

  def user_belongs_to_organisation
    record.memberships.where(user: user).exists?
  end

  def user_is_admin_in_organisation
    record.memberships.where(user: user, is_organisation_admin: true).exists?
  end
end
