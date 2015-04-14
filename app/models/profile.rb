class Profile < ActiveRecord::Base
  belongs_to :user
  has_many :memberships
  has_many :organisations, through: :memberships

  validates :name, :address, :postcode, :email, :tel, :mobile, presence: true

  validates :user_id, uniqueness: true, allow_nil: true

  # It is not valid to have multiple memberships for a single organisation
  # so we can safely always call .first as only one will be returned
  def membership_for organisation
    memberships.where(organisation: organisation).first
  end
end
