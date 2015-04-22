require 'active_support/core_ext/string/inflections'

module Drs
  module AuthClient
    module Models
      class Base
        attr_accessor :uid

        def initialize(attributes)
          attributes.each do |key, value|
            writer = "#{key}="
            send(writer, value) if respond_to?(writer)
          end
        end

        def self.from_hash(hash)
          if hash.has_key?(single_resource_data_key)
            new(hash[single_resource_data_key])
          end
        end

        def self.collection_from_hash(hash)
          if hash.has_key?(collection_resource_data_key)
            hash[collection_resource_data_key].map { |attributes| new(attributes) }
          else
            []
          end
        end

        private

        def self.single_resource_data_key
          resource_data_key.to_sym
        end

        def self.collection_resource_data_key
          resource_data_key.pluralize.to_sym
        end

        def self.resource_data_key
          self.name.split('::').last.underscore
        end
      end
    end
  end
end
