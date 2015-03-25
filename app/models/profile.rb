class Profile < ActiveRecord::Base
  belongs_to :user
  has_many :memberships
  has_many :organisations, through: :memberships

  validates :name, :address, :postcode, :email, :tel, presence: true
end
