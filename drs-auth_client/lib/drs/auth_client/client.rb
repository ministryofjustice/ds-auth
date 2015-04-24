require "active_support/core_ext/hash/keys"
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

      def get(path)
        response = conn.get do |request|
          request.url path
          request.headers['Authorization'] = "Bearer #{@auth_token}"
        end

        if response.status == 200
          response.body
        else
          nil
        end
      end

      (Models.constants - [:Base]).each do |model_name|
        model = Models.const_get(model_name)
        single_resource_name = model_name.to_s.underscore.downcase
        collection_resource_name = single_resource_name.pluralize

        define_method(single_resource_name) do |uid|
          path = "#{collection_resource_name}/#{uid}"
          get_resource(path, model, :from_hash, nil)
        end

        define_method(collection_resource_name) do
          get_resource(collection_resource_name, model, :collection_from_hash, [])
        end
      end

      private

      def parse_response(response)
        JSON.parse(response).deep_symbolize_keys
      end

      def get_resource(path, model, model_method, default_result)
        response = get(path)
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