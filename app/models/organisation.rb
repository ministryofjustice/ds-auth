class Organisation < ActiveRecord::Base
  ORGANISATION_TYPES = [
    "call_centre",
    "custody_suite",
    "law_firm",
    "law_office"
  ]

  has_many :permissions
  has_many :memberships
  has_many :profiles, through: :memberships

  has_many :sub_organisations, class_name: "Organisation", foreign_key: "parent_organisation_id"
  belongs_to :parent_organisation, class_name: "Organisation"

  validates :slug, :name, :organisation_type, presence: true
  validates :organisation_type, inclusion: { in: ORGANISATION_TYPES }
  validate :no_circular_references

  scope :by_name, -> { order(name: :asc) }

  private

  def no_circular_references(organisation=self)
    if organisation.parent_organisation == self
      errors.add(:parent_organisation, "cannot cause circular references")
    elsif organisation.parent_organisation.present?
      no_circular_references(organisation.parent_organisation)
    end
  end
end
