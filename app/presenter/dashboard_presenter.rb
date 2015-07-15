class DashboardPresenter
  include ActionView::Helpers::TagHelper
  include ActionView::Helpers::UrlHelper
  include ActionView::Context

  attr_reader :user

  def initialize(user)
    @user = user
  end

  def application_links
    applications.map do |application|
      content_tag :li do
        link_to application.name, application.url, target: "_blank"
      end
    end.join.html_safe
  end

  def has_applications?
    applications.count > 0
  end

  private

  def applications
    @applications ||= Doorkeeper::Application.where(name: application_names)
  end

  def application_names
    user.application_names
  end
end
