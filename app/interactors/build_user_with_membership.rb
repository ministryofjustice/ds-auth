class BuildUserWithMembership
  def initialize(organisation:, user_params: {}, membership_params: {})
    @organisation, @user_params, @membership_params = organisation, user_params, membership_params
  end

  def call
    build_user
    build_membership
    user
  end

  private

  attr_reader :user, :user_params, :organisation, :membership_params

  def build_user
    @user = User.new user_params
  end

  def build_membership
    user.memberships.build membership_params.merge(organisation: organisation)
  end
end
