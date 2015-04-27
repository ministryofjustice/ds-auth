class StaticController < ApplicationController
  protect_from_forgery except: :expired

  def help
    render "help"
  end

  def accessibility
    render "accessibility"
  end

  def cookies
    render "cookies"
  end

  def expired
    render "expired"
  end

  def terms
    render "terms"
  end
end
