module ResponseJSON
  def response_json
    JSON.parse(response.body)
  end
end

RSpec.configure { |config| config.include ResponseJSON }
