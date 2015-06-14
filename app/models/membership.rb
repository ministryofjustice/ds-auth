class Membership < ActiveRecord::Base
  belongs_to :organisation
  belongs_to :user

  store_accessor :permissions, :roles, :applications

  scope :with_roles, ->(*roles) {
    where("permissions -> 'roles' ?& array['#{Array(roles).join("','")}']")
  }

  scope :with_any_role, ->(*roles) {
    where("permissions -> 'roles' ?| array['#{Array(roles).join("','")}']")
  }

  def roles
    Array super
  end

  def roles=(val)
    super Array(val).keep_if {|r| r.present? }
  end

  def applications
    Array super
  end

  def applications=(val)
    super Array(val).keep_if {|r| r.present? }
  end
end
