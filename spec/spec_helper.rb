unless ENV["NO_COVERAGE"]
  require "simplecov"

  # Report code coverage to codeclimate
  if ENV["CODECLIMATE_REPO_TOKEN"]
    require "codeclimate-test-reporter"
    CodeClimate::TestReporter.start
  end

  # On circleci change the output dir to the artifacts
  if ENV["CIRCLE_ARTIFACTS"]
    SimpleCov.coverage_dir File.join("..", "..", "..", ENV["CIRCLE_ARTIFACTS"], "coverage")
  end

  SimpleCov.start "rails" do
    add_group "Policies", "app/policies"
    add_group "Services", "app/services"
    add_group "Validators", "app/validators"

    if defined?(CodeClimate)
      formatter SimpleCov::Formatter::MultiFormatter[
        SimpleCov::Formatter::HTMLFormatter,
        CodeClimate::TestReporter::Formatter
      ]
    end
  end
end

require "webmock/rspec"

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
    expectations.syntax = :expect
  end

  config.mock_with :rspec do |mocks|
    mocks.syntax = :expect
    mocks.verify_partial_doubles = true
  end

  config.disable_monkey_patching!
  config.order = :random
end

WebMock.disable_net_connect!(allow_localhost: true, allow: "codeclimate.com")
