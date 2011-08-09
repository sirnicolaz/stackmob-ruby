require 'helper'

class StackMobDeployerTest < MiniTest::Unit::TestCase
  
  def setup
    @mock_client = mock("StackMob::Client")
    @deployer = StackMob::Deployer.new(@mock_client)
  end

  def test_register_call
    hostname = "testing1234"
    @mock_client.expects(:request).with(:post, :api, "heroku/app", :hostname => hostname)
    @deployer.register(hostname)
  end

  def test_fetch_call
    @mock_client.expects(:request).with(:get, :api, "heroku/app")
    @deployer.fetch
  end

end
