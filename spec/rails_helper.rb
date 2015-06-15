ENV["RAILS_ENV"] ||= "test"

require File.expand_path("../../config/environment", __FILE__)

require "rspec/rails"
require "shoulda-matchers"
require "capybara/poltergeist"

Dir[Rails.root.join("spec/support/**/*.rb")].each { |file| require file }


WebMock.disable_net_connect!(allow_localhost: true, allow: ["codeclimate.com"])

RSpec.configure do |config|
  config.include HelperMethods

  config.fixture_path = "#{::Rails.root}/spec/fixtures"
  config.use_transactional_fixtures = false
  config.infer_spec_type_from_file_location!
  config.disable_monkey_patching!
end

ActiveRecord::Migration.maintain_test_schema!

Capybara.javascript_driver = :poltergeist

Capybara.register_driver :poltergeist do |app|
  Capybara::Poltergeist::Driver.new(app, {
                                         phantomjs_logger: File.open("#{Rails.root}/log/test_phantomjs.log", "a"),
                                       })
end
