class ApplicationController < ActionController::Base
  include Pundit
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

   protect_from_forgery with: :exception

   before_action :authenticate_user!
   before_action :set_user_current

   def flash_message(type, klass)
     t("models.#{type}", model: klass.model_name.human)
   end

  private

  def user_not_authorized
    flash[:alert] = t("not_authorized")
    redirect_to(request.referrer || root_path)
  end

  def after_sign_out_path_for(resource_or_scope)
    new_user_session_path
  end

  def set_user_current
    User.current = current_user
  end
end
