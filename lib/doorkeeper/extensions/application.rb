require "active_support/concern"

module Doorkeeper
  module Extensions
    module Application
      extend ActiveSupport::Concern

      def available_roles
        @available_roles ||= ::RoleLoader.new.available_roles_for_application name
      end

      def available_role_names
        available_roles.map(&:name)
      end

      def url
        @url || URI.parse(redirect_uri).tap do |uri|
          uri.path = "/"
        end.to_s
      end
    end
  end
end

Doorkeeper::Application.send :include, Doorkeeper::Extensions::Application
