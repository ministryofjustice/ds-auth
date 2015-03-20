class Person < ActiveRecord::Base
  belongs_to :user
  has_many :organisation_memberships
  has_many :organisations, through: :organisation_memberships

  validates :name,
            :address,
            :postcode,
            :email,
            :tel, presence: true
end
