class OrganisationMembership < ActiveRecord::Base
  belongs_to :profile
  belongs_to :organisation
end
