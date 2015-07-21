module DoorkeeperHelper
  def authorization_status(application)
    tick_cross_mark application.handles_own_authorization
  end
end
