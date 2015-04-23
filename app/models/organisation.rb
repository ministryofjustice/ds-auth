class Organisation < ActiveRecord::Base
  ORGANISATION_TYPES = {
    "Call centre" => "call_centre",
    "Custody suite" => "custody_suite",
    "Law firm" => "law_firm",
    "Law office" => "law_office"
  }

  has_many :permissions
  has_many :memberships
  has_many :profiles, through: :memberships

  has_many :sub_organisations, class_name: "Organisation", foreign_key: "parent_organisation_id"
  belongs_to :parent_organisation, class_name: "Organisation"

  validates :slug, :name, :organisation_type, presence: true
  validate :no_circular_references

  scope :by_name, -> { order(name: :asc) }

  private

  def no_circular_references(organisation=self)
    if organisation.parent_organisation == self
      errors.add(:parent_organisation, 'cannot cause circular references')
    elsif organisation.parent_organisation.present?
      no_circular_references(organisation.parent_organisation)
    end
  end
end
