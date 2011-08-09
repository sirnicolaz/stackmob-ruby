require 'integration_helper'

class DeployerIntegrationTest < StackMobIntegrationTest  
  
  def setup
    super

    @deployer = StackMob::Deployer.new(valid_client)
    @hostname1 = "test.localhost"
    @hostname2 = "test.localhost.2"
  end

  def test_register_and_fetch_app
    @deployer.register(@hostname1)
    
    assert_equal @hostname1, @deployer.fetch['hostname']

    @deployer.register(@hostname2)

    assert_equal @hostname2, @deployer.fetch['hostname']
  end

end
