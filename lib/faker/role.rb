require 'faker'

module Faker
  class Role < Base
    def self.name
      fetch('role.name')
    end
  end
end
