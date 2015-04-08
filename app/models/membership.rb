class Membership < ActiveRecord::Base
  belongs_to :profile
  belongs_to :organisation

  validates_uniqueness_of :profile_id, scope: :organisation_id
  validates_presence_of :profile, :organisation
end
