
revoke_all_tokens_for_user = Proc.new do |user|
  Doorkeeper::AccessToken.where(resource_owner_id: user.id,
                                revoked_at: nil).
                                map(&:revoke)
end

Warden::Manager.before_logout(&revoke_all_tokens_for_user)
