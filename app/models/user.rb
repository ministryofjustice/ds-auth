class User < ActiveRecord::Base
  devise :database_authenticatable, :recoverable, :rememberable, :trackable, :validatable

  has_many :permissions
  has_one :profile

  delegate :name, to: :profile

  def roles_for(application: )
    permissions.for_application(application).map(&:role)
  end
end
