class Membership < ActiveRecord::Base
  belongs_to :organisation
  belongs_to :user

  store_accessor :permissions, :roles, :applications

  validates_presence_of :user, :organisation
  validates_uniqueness_of :user_id, scope: [:organisation_id]

  scope :with_roles, ->(*roles) {
    where("permissions -> 'roles' ?& array[:roles]", roles: Array(*roles))
  }

  scope :with_any_role, ->(*roles) {
    where("permissions -> 'roles' ?| array[:roles]", roles: Array(*roles))
  }

  def roles
    Array super
  end

  def roles=(val)
    super Array(val).keep_if(&:present?)
  end

  def applications
    Array super
  end

  def applications=(val)
    super Array(val).keep_if(&:present?)
  end
end
