class Organisation < ActiveRecord::Base
  ORGANISATION_TYPES = %w{
    drs_call_center
    laa_rota_team
    court
    custody_suite
    law_firm
    law_office
  }

  has_many :memberships
  has_many :users, through: :memberships

  has_many :sub_organisations, -> { order :id }, class_name: "Organisation", foreign_key: "parent_organisation_id"
  belongs_to :parent_organisation, class_name: "Organisation"

  validates :slug, :name, :organisation_type, presence: true
  validates :organisation_type, inclusion: { in: ORGANISATION_TYPES }
  validate :no_circular_references

  scope :by_name, -> { order(name: :asc) }

  store_accessor :details, :supplier_number

  def is_law_firm?
    organisation_type == "law_firm" || organisation_type == "law_office"
  end

  def available_roles
    @available_roles ||= RoleLoader.new.available_roles_for_organisation_type organisation_type
  end

  def default_role_names
    @default_roles ||= RoleLoader.new.default_roles_for_organisation_type organisation_type
  end

  def available_role_names
    available_roles.map(&:name)
  end

  def self.create_from_attributes(orgs_attrs)
    Organisation.transaction do
      orgs_attrs.each_pair do |org_name, org_attrs|
        users_attrs = org_attrs.delete(:users)

        org = Organisation.where(name: org_name).first_or_initialize do |o|
          o.assign_attributes(org_attrs)
        end

        unless org.save
          raise ActiveRecord::Rollback
        end

        users_attrs.each do |user_attrs|
          user = User.where(email: user_attrs[:email]).first_or_initialize do |u|
            u.assign_attributes(user_attrs)
          end

          unless user.save
            raise ActiveRecord::Rollback
          end

          Membership.where(user_id: user.id, organisation_id: org.id).first_or_create! do |m|
            m.roles = org.default_role_names
          end
        end
      end
    end
  end

  private

  def no_circular_references(organisation=self)
    if organisation.parent_organisation == self
      errors.add(:parent_organisation, "cannot cause circular references")
    elsif organisation.parent_organisation.present?
      no_circular_references(organisation.parent_organisation)
    end
  end
end
