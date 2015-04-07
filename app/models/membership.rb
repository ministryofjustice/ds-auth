class Membership < ActiveRecord::Base
  belongs_to :profile
  belongs_to :organisation

  validates_presence_of :profile, :organisation
end
