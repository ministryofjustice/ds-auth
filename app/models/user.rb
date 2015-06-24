class User < ActiveRecord::Base
  devise :database_authenticatable, :recoverable, :rememberable, :trackable, :validatable, :timeoutable

  has_many :memberships, dependent: :destroy
  has_many :organisations, through: :memberships

  validates_presence_of :name

  default_scope { order :name }
  scope :by_name, -> { order(name: :asc) }

  def role_names_for(application: )
    memberships.with_any_role(*application.available_role_names).map(&:roles).flatten
  end

  def roles
    memberships.map(&:roles).flatten
  end
end
