class Profile < ActiveRecord::Base
  belongs_to :user, dependent: :destroy
  has_many :memberships, dependent: :destroy
  has_many :organisations, through: :memberships

  default_scope { order :name }
  scope :by_name, -> { order(name: :asc) }

  # It is not valid to have multiple memberships for a single organisation
  # so we can safely always call .first as only one will be returned
  def membership_for(organisation)
    memberships.where(organisation: organisation).first
  end

  attr :associated_user

  def associated_user=(string_value)
    @associated_user = (string_value == "1")
  end
end
