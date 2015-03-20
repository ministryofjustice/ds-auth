class GovernmentApplication < ActiveRecord::Base
  has_many :permissions
  belongs_to :oauth_application, class_name: 'Doorkeeper::Application'
end
