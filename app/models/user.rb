class User < ActiveRecord::Base
  devise :database_authenticatable, :recoverable, :rememberable, :trackable, :validatable

  has_many :permissions
  has_many :roles, through: :permissions
  has_one :person

  scope :without_user, ->(user) { where.not(id: user.id) }
end
