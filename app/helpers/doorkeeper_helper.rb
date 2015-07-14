module DoorkeeperHelper
  def authorization_status(application)
    application.only_allow_authorized_login ? "✓" : "✗"
  end
end
