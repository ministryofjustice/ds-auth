class ApplicationMembership < ActiveRecord::Base
  belongs_to :application, class_name: "Doorkeeper::Application"
  belongs_to :membership

  validates_presence_of :application, :membership
  validate :validate_application_available_to_user

  delegate :name, to: :application, prefix: true, allow_nil: true

  def has_roles?
    roles.present?
  end

  private

  # Sense check that the application has been made available to at least 1 of
  # the users organisations
  # Stops malicious access to other applications
  def validate_application_available_to_user
    return unless membership

    unless membership.has_access_to_application?(application)
      errors.add :application, :application_not_available, app_name: application_name, organisation_name: membership.organisation.name
    end
  end
end
