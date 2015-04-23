require 'active_support/core_ext/hash/keys'
require 'active_support/core_ext/string/inflections'
require 'faraday'

require 'drs/auth_client/models/organisation'
require 'drs/auth_client/models/profile'

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
          single_resource_get("#{collection_resource_name}/#{uid}", model)
        end

        define_method(collection_resource_name) do
          collection_resource_get(collection_resource_name, model)
        end
      end

      # def organisation(uid)
      #   single_resource_get("organisations/#{uid}", Models::Organisation)
      # end
      #
      # def organisations
      #   collection_resource_get("organisations", Models::Organisation)
      # end
      #
      # def profile(uid)
      #   single_resource_get("profiles/#{uid}", Models::Profile)
      # end
      #
      # def profiles
      #   collection_resource_get("profiles", Models::Profile)
      # end

      private

      def resource_get(path)
        JSON.parse(get(path)).deep_symbolize_keys
      end

      def single_resource_get(path, model)
        hash = resource_get(path)
        model.from_hash(hash)
      end

      def collection_resource_get(path, model)
        hash = resource_get(path)
        model.collection_from_hash(hash) 
      end

      def conn
        api_url = "#{AuthClient.host}/api/#{AuthClient.version}"

        Faraday.new(api_url)
      end
    end
  end
end