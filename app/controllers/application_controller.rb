class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :authenticate_user!

  def flash_message(type, klass)
    t("models.#{type}", model: klass.model_name.human)
  end
end
