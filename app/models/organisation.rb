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
    (organisation_type_data["available_roles"].map do |name, applications|
      Role.new name, applications
    end) + default_available_roles
  end

  def default_roles
    organisation_type_data["default_roles"] + default_default_roles
  end

  private

  def no_circular_references(organisation=self)
    if organisation.parent_organisation == self
      errors.add(:parent_organisation, "cannot cause circular references")
    elsif organisation.parent_organisation.present?
      no_circular_references(organisation.parent_organisation)
    end
  end

  def default_available_roles
    load_organisation_types["default"]["available_roles"].map do |name, applications|
      Role.new name, applications
    end
  end

  def default_default_roles
    load_organisation_types["default"]["default_roles"]
  end

  def organisation_type_data
    load_organisation_types[organisation_type]
  end

  def load_organisation_types
    @load_organisation_type ||= YAML::load File.open(Rails.root + "config/organisation_types.yml")
  end
end
