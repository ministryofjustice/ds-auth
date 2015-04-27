ENV["BUNDLE_GEMFILE"] ||= File.expand_path("../../Gemfile", __FILE__)

require "bundler/setup" # Set up gems listed in the Gemfile.
require "rails/commands/server"

# Import environment variables when dotenv is available
if Gem::Specification.find_all_by_name("dotenv").any?
  require "dotenv/rails-now"
  Dotenv::Railtie.load
end

module Rails
  class Server
    alias :default_options_alias :default_options
    def default_options
      port = ENV.fetch("SERVER_PORT") { "3000" }
      default_options_alias.merge!(Port: port)
    end
  end
end
