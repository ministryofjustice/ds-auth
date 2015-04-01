class Permission < ActiveRecord::Base
  belongs_to :user
  belongs_to :role
  belongs_to :government_application
  belongs_to :organisation

  validates :user, :role, :government_application, presence: true
  validates_uniqueness_of :user_id, scope: [:role_id, :government_application_id, :organisation_id]
end
