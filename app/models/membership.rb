class Membership < ActiveRecord::Base
  belongs_to :organisation
  belongs_to :user

  has_many :application_memberships, dependent: :destroy, inverse_of: :membership

  validates_presence_of :user, :organisation
  validates_uniqueness_of :user_id, scope: [:organisation_id]

  accepts_nested_attributes_for :application_memberships

  def application_names
    application_memberships.map(&:application_name)
  end

  def has_access_to_application?(application)
    organisation.has_access_to_application?(application)
  end

  def roles_for_application(application)
    application_membership_for_application(application).try(:roles) || []
  end

  private

  def application_membership_for_application(application)
    application_memberships.where(application: application).first
  end
end
