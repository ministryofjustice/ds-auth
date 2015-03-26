worker_processes Integer(ENV["WEB_CONCURRENCY"] || 3)
listen Integer(ENV.fetch('UNICORN_PORT', 3000))

pid File.expand_path('../../tmp/pids/unicorn.pid', __FILE__)
listen File.expand_path('../../tmp/sockets/unicorn.sock', __FILE__), backlog: 64

timeout 15
preload_app true

before_fork do |server, worker|
  Signal.trap 'TERM' do
    puts 'Unicorn master intercepting TERM and sending myself QUIT instead'
    Process.kill 'QUIT', Process.pid
  end

  defined?(ActiveRecord::Base) and
    ActiveRecord::Base.connection.disconnect!
end

after_fork do |server, worker|
  Signal.trap 'TERM' do
    puts 'Unicorn worker intercepting TERM and doing nothing. Wait for master to send QUIT'
  end

  defined?(ActiveRecord::Base) and
    ActiveRecord::Base.establish_connection
end
