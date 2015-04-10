APP_PATH = File.expand_path("../..", __FILE__)
FOREMAN = ENV.key? 'FOREMAN'

worker_processes Integer(ENV.fetch("WEB_CONCURRENCY", 3))
listen Integer(ENV.fetch("UNICORN_PORT", 3000))

stderr_path File.join(APP_PATH, "log", "unicorn.stderr.log") unless FOREMAN
stdout_path File.join(APP_PATH, "log", "unicorn.stderr.log") unless FOREMAN

pid File.join(APP_PATH, "tmp", "pids", "unicorn.pid")
listen File.join(APP_PATH, "tmp", "sockets", "unicorn.sock"), backlog: 64

timeout 15
preload_app true

before_fork do |server, worker|
  Signal.trap "TERM" do
    puts "Unicorn master intercepting TERM and sending myself QUIT instead"
    Process.kill "QUIT", Process.pid
  end

  defined?(ActiveRecord::Base) and
    ActiveRecord::Base.connection.disconnect!
end

after_fork do |server, worker|
  Signal.trap "TERM" do
    puts "Unicorn worker intercepting TERM and doing nothing. Wait for master to send QUIT"
  end

  defined?(ActiveRecord::Base) and
    ActiveRecord::Base.establish_connection
end
