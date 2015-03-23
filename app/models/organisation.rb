class Organisation < ActiveRecord::Base
  has_many :permissions
  has_many :organisation_memberships
  has_many :people, through: :organisation_memberships

  validates :slug,
            :name,
            :organisation_type,
             presence: true
end
