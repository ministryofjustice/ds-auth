class Permission < ActiveRecord::Base
  belongs_to :user
  belongs_to :role
  belongs_to :government_application
  belongs_to :organisation

  validates :government_application, :role, presence: true
end
