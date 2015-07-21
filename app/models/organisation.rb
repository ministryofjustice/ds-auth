class Organisation < ActiveRecord::Base
  has_and_belongs_to_many :applications, class_name: "Doorkeeper::Application",
    join_table: :applications_organisations, association_foreign_key: :oauth_application_id

  has_many :memberships
  has_many :users, through: :memberships

  has_many :sub_organisations, -> { order :id }, class_name: "Organisation", foreign_key: "parent_organisation_id"
  belongs_to :parent_organisation, class_name: "Organisation"

  validates :slug, :name, presence: true
  validate :no_circular_references

  scope :by_name, -> { order(name: :asc) }

  store_accessor :details, :supplier_number

  def available_roles
    applications.map(&:available_roles).flatten.uniq.sort
  end

  def has_access_to_application?(application)
    applications.exists?(application.id)
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
