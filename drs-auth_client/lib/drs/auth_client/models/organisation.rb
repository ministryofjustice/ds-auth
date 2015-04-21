module Drs
  module AuthClient
    module Models
      class Organisation
        attr_accessor :uid

        def initialize(attributes)
          attributes.each do |key, value|
            writter = "#{key}="
            send(writter, value) if respond_to?(writter)
          end
        end

        def self.from_hash(hash)
          if hash.has_key?(:organisation)
            new(hash[:organisation])
          end
        end

        def self.collection_from_hash(hash)
          organisations = []

          if hash.has_key?(:organisations)
            organisations = hash[:organisations].map { |attributes| new(attributes) }
          end

          organisations
        end
      end
    end
  end
end
