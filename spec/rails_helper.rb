unless ENV['NO_COVERAGE']
  require 'simplecov'

  # Report code coverage to codeclimate
  if ENV['CODECLIMATE_REPO_TOKEN']
    require 'codeclimate-test-reporter'
    CodeClimate::TestReporter.start
  end

  # On circleci change the output dir to the artifacts
  if ENV['CIRCLE_ARTIFACTS']
    SimpleCov.coverage_dir File.join('..', '..', '..', ENV['CIRCLE_ARTIFACTS'], 'coverage')
  end

  SimpleCov.start 'rails' do
    add_group 'Policies', 'app/policies'
    add_group 'Services', 'app/services'
    add_group 'Validators', 'app/validators'

    if defined?(CodeClimate)
      formatter SimpleCov::Formatter::MultiFormatter[
                  SimpleCov::Formatter::HTMLFormatter,
                  CodeClimate::TestReporter::Formatter
                ]
    end
  end
end

ENV['RAILS_ENV'] ||= 'test'
require 'spec_helper'
require File.expand_path('../../config/environment', __FILE__)
require 'rspec/rails'
require 'capybara/rails'
require 'capybara/rspec'
require 'webmock/rspec'
require 'shoulda-matchers'
require 'database_cleaner'

WebMock.disable_net_connect!(allow_localhost: true, allow: ['codeclimate.com'])

Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  config.fixture_path = "#{::Rails.root}/spec/fixtures"
  config.use_transactional_fixtures = false

  config.before :each do
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.start
    ActionMailer::Base.deliveries = []
  end

  config.after :each do
    DatabaseCleaner.clean
  end

  config.include HelperMethods

  config.infer_spec_type_from_file_location!

  config.disable_monkey_patching!
end
