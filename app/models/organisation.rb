class Organisation < ActiveRecord::Base
  has_many :permissions
  has_many :memberships
  has_many :profiles, through: :memberships

  validates :slug, :name, :organisation_type, presence: true

  scope :by_name, -> { order(name: :asc) }
end
