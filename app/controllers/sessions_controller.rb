class SessionsController < Devise::SessionsController
  protect_from_forgery with: :exception, except: :destroy
end
