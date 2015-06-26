module Api::V1
  class ApiController < ApplicationController
    protect_from_forgery with: :null_session
    skip_before_action :authenticate_user!
    before_action :doorkeeper_authorize!

    private

    def current_resource_owner
      User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
    end

    # See https://github.com/doorkeeper-gem/doorkeeper/blob/master/lib/doorkeeper/rails/helpers.rb
    def doorkeeper_unauthorized_render_options
      { json: { errors: [doorkeeper_error.description] } }
    end
  end
end
