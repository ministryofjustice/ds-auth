class User < ActiveRecord::Base
  devise :database_authenticatable, :recoverable, :rememberable, :trackable, :validatable, :timeoutable

  has_many :memberships, dependent: :destroy
  has_many :organisations, through: :memberships

  validates_presence_of :name

  default_scope { order :id }
  scope :by_name,  -> { order(name: :asc) }

  def can_login_to_application?(application)
    memberships
    .joins(:application_memberships)
    .joins("INNER JOIN oauth_applications ON oauth_applications.id = application_memberships.application_id")
    .where(application_memberships: { application: application})
    .where(%{
      (oauth_applications.handles_own_authorization = 't' AND application_memberships.can_login = 't')
      OR
      (oauth_applications.handles_own_authorization = 'f' AND array_length(application_memberships.roles, 1) > 0)
    }).exists?
  end

  def member_of?(organisation)
    memberships.where(organisation: organisation).exists?
  end

  def application_names
    memberships.map(&:application_names).flatten.uniq
  end

  def roles_for_application(application_id)
    memberships
      .joins(:application_memberships)
      .where(application_memberships: {application_id: application_id})
      .map{|m| m.roles_for_application(application_id)}
      .flatten.uniq
  end

  def self.current
    Thread.current[:user]
  end

  def self.current=(user)
    Thread.current[:user] = user
  end
end
