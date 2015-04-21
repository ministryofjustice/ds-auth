require 'drs/auth_client/version'

module Drs
  module AuthClient
    class << self
      attr_accessor :host, :version

      def configure
        yield self
      end
    end
  end
end
