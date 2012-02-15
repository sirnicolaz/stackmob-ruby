require 'support/utils'

module TestHelpers
  include Utils
  
  def run_cli(*argv)
    run_cli_base(*argv) do |argv|
      StackMob::CLI::Main.start(argv)
    end
  end

  def kill!
    Process.kill(9, @pid) if @pid
  end


  private
  
  def run_cli_base(*argv)
    kill!

    @pid = Process.fork do 
      yield argv
    end

    if argv.first == "server"
      wait_for_local_server
    end

    @pid
  end

end
