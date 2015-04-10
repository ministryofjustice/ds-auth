class Permission < ActiveRecord::Base
  belongs_to :user
  belongs_to :role
  belongs_to :application, class_name: "Doorkeeper::Application"
  belongs_to :organisation

  validates :user, :role, :application, presence: true
  validates_uniqueness_of :user_id, scope: [:role_id, :application_id, :organisation_id]
end
