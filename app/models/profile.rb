class Profile < ActiveRecord::Base
  belongs_to :user, dependent: :destroy
  has_many :memberships
  has_many :organisations, through: :memberships

  accepts_nested_attributes_for :user

  validates :name, :address, :postcode, :email, presence: true

  validates :user_id, uniqueness: true, allow_nil: true

  validates :email, uniqueness: true, email: { strict_mode: true }

  phony_normalize :tel, :mobile, default_country_code: "GB"
  validates_plausible_phone :tel, :mobile, presence: true

  scope :by_name, -> { order(name: :asc) }

  # It is not valid to have multiple memberships for a single organisation
  # so we can safely always call .first as only one will be returned
  def membership_for organisation
    memberships.where(organisation: organisation).first
  end

  attr :associated_user

  def associated_user=(string_value)
    @associated_user = (string_value == "1")
  end
end
