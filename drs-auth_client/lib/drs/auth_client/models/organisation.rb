require_relative "base"

module Drs
  module AuthClient
    module Models
      class Organisation < Base
        attr_accessor :name, :type
      end
    end
  end
end
