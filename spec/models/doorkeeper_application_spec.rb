require "rails_helper"

RSpec.describe Doorkeeper::Application do
  describe "associations" do
    specify { expect(subject).to have_many(:permissions) }
  end
end
