# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

if ARGV.length == 0 || ARGV == ["spec"]
  # If we run 'bundle exec rake' or 'bundle exec rake spec' without an
  # environment, we would like the default environment behaviour to follow the
  # standard rails convention of using the test environment. However, because
  # dotenv loads environment variables before the spec helper gets to switch the
  # environment, this breaks things. We thus force RAILS_ENV to be 'test' if
  # anyone runs rake without arguments, or just 'rake spec'.
  # This has to happen before the application is loaded below.
  ENV["RAILS_ENV"] ||= "test"
end

require File.expand_path("../config/application", __FILE__)

Rails.application.load_tasks
