module Utils

  def wait_for_local_server(port = StackMob::CLI::LocalServer::DEFAULT_PORT)
    s = TCPSocket.new('0.0.0.0', port)
    puts "local server started on port: #{port}"
  rescue Errno::ECONNREFUSED
    sleep 0.2
    retry
  ensure
    s.close if s
  end

end
