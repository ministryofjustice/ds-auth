require 'faker'

module Faker
  class Role < Base
    class << self
      def name
        fetch('role.name')
      end

      def by_index i
        all_values.fetch(i) { require 'pry'; binding.pry }
      end

      private

      def all_values
        @values ||= translate('faker.role.name')
      end
    end
  end
end
