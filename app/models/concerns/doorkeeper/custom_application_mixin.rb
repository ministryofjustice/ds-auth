module Doorkeeper
  module CustomApplicationMixin
    extend ActiveSupport::Concern

    included do
      validates :failure_uri, failure_uri: true
    end
  end
end
