ENV["RAILS_ENV"] ||= "test"

require File.expand_path("../../config/environment", __FILE__)

require "rspec/rails"
require "shoulda-matchers"

Dir[Rails.root.join("spec/support/**/*.rb")].each { |file| require file }


WebMock.disable_net_connect!(allow_localhost: true, allow: ['codeclimate.com'])

RSpec.configure do |config|
  config.include HelperMethods

  config.fixture_path = "#{::Rails.root}/spec/fixtures"
  config.use_transactional_fixtures = false
  config.infer_spec_type_from_file_location!
  config.disable_monkey_patching!
end

ActiveRecord::Migration.maintain_test_schema!
