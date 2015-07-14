module DoorkeeperHelper
  def authorization_status(application)
    application.handles_own_authorization ? "✓" : "✗"
  end
end
