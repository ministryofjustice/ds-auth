require "active_support/core_ext/hash/keys"
require "active_support/core_ext/object/blank"
require "active_support/core_ext/string/inflections"
require "faraday"

require "drs/auth_client/models/organisation"
require "drs/auth_client/models/profile"

module Drs
  module AuthClient
    class Client
      def initialize(auth_token)
        @auth_token = auth_token
      end

      def get(path, options = {})
        raise Errors::Unauthorised if @auth_token.blank?

        response = conn.get do |request|
          request.url path
          request.headers["Authorization"] = "Bearer #{@auth_token}"
          request.params = options
        end

        process_response(response)
      end

      #
      # Resource access methods
      #
      def organisation(id)
        get_resource("organisations/#{id}", Models::Organisation, :from_hash, nil)
      end

      def organisations(options = {})
        get_resource("organisations", Models::Organisation, :collection_from_hash, [], options)
      end

      def profile(id)
        get_resource("profiles/#{id}", Models::Profile, :from_hash, nil)
      end

      def profiles(options = {})
        get_resource("profiles", Models::Profile, :collection_from_hash, [], options)
      end

      private

      def process_response(response)
        case (response.status)
          when 401
            raise Errors::Unauthorised
          when 403
            raise Errors::Forbidden
          when 500
            raise Errors::Internal
          when 200
            response.body
        end
      end

      def parse_response(response)
        JSON.parse(response).deep_symbolize_keys
      end

      def get_resource(path, model, model_method, default_result, options = {})
        response = get(path, options)
        if response
          model.send(model_method, parse_response(response))
        else
          default_result
        end
      end

      def conn
        api_url = "#{AuthClient.host}/api/#{AuthClient.version}"

        Faraday.new(api_url)
      end
    end
  end
end
