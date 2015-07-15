class BuildUserWithMembership
  def initialize(organisation:, user_params: {})
    @organisation, @user_params, @membership_params = organisation, user_params
  end

  def call
    build_user
    build_membership
    user
  end

  private

  attr_reader :user, :user_params, :organisation

  def build_user
    @user = User.new user_params
  end

  def build_membership
    user.memberships.build organisation: organisation
  end
end
