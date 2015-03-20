class Person < ActiveRecord::Base
  validates :name, presence: true
  belongs_to :user
  has_many :organisation_memberships
  has_many :organisations, through: :organisation_memberships
end
