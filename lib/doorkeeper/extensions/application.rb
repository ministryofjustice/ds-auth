require "active_support/concern"

module Doorkeeper
  module Extensions
    module Application
      extend ActiveSupport::Concern

      included do
        has_many :permissions
      end

      def available_roles
        load_organisation_types.map do |organisation_type, data|
          data["available_roles"].map do |role_name, applications|
            role_name if applications.include?(name)
          end
        end.flatten.compact.uniq.sort
      end

      private

      def load_organisation_types
        @load_organisation_type ||= YAML::load File.open(::Rails.root + "config/organisation_types.yml")
      end
    end
  end
end

Doorkeeper::Application.send :include, Doorkeeper::Extensions::Application
