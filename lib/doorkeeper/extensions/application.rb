module Doorkeeper
  module Extensions
    module Application
      extend ActiveSupport::Concern

      included do
        has_and_belongs_to_many :organisations, join_table: :applications_organisations, foreign_key: :oauth_application_id
        has_many :application_memberships, dependent: :destroy

        validates :name, uniqueness: true
        validates :failure_uri, failure_uri: true
      end

      def available_roles_as_string
        available_roles.join "\r\n"
      end

      def available_roles_as_string=(str)
        self.available_roles= str.split("\r\n")
      end

      def url
        @url || URI.parse(redirect_uri).tap do |uri|
          uri.path = "/"
        end.to_s

        rescue URI::InvalidURIError
          redirect_uri
      end
    end
  end

  Application.send :include, Extensions::Application
end
