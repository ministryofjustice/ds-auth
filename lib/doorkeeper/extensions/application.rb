require "active_support/concern"

module Doorkeeper
  module Extensions
    module Application
      extend ActiveSupport::Concern

      included do
        has_many :permissions
      end
    end
  end
end

Doorkeeper::Application.send :include, Doorkeeper::Extensions::Application
