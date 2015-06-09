require_relative "../../lib/ping_response"

class StatusController < ApplicationController
  skip_before_filter :authenticate_user!

  def index
    respond_to do |format|
      format.json { render json: {"status" => "OK"} }
      format.xml { render xml: {"Status" => "OK"}.to_xml(root: "Response") }
      format.any { render text: "OK"}
    end
  end

  def ping
    # If there's a problem, we need to return an error 500
    ping_response = PingResponse.new

    status = ping_response.ok? ? :ok : :error

    respond_to do |format|
      # When debugging problems at 3am, support staff might not specify the JSON
      # content type. We return JSON in all cases.
      format.all { render json: ping_response.data, status: status }
    end
  end
end
