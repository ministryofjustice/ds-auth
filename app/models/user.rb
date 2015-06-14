class User < ActiveRecord::Base
  devise :database_authenticatable, :recoverable, :rememberable, :trackable, :validatable

  has_many :memberships
  has_many :organisations, through: :memberships

  validates_presence_of :name

  def roles_for(application: )
    # permissions.for_application(application).map(&:role)
    memberships.with_any_role(application.available_roles).map(&:roles).flatten
  end
end
