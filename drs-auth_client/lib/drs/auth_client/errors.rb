module Drs
  module AuthClient
    module Errors
      class Unauthorised < StandardError
      end

      class Forbidden < StandardError
      end

      class Internal < StandardError
      end
    end
  end
end