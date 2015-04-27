require "faker"

module Faker
  class Role < Base
    class << self
      def by_index i
        all_values.fetch(i) { raise NotEnoughRoles, "You only have #{i} roles defined, and you tried to access number #{i+1}!" }
      end

      private

      def all_values
        @values ||= translate("faker.role.name")
      end
    end
  end

  class NotEnoughRoles < StandardError; end
end
