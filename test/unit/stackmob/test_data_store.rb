require 'helper'

class StackMobDataStoreTest < MiniTest::Unit::TestCase
  
  def setup
    @mock_client = mock("StackMob::Client")
    @datastore = StackMob::DataStore.new(@mock_client)
  end

  def test_given_client_is_returned_client
    assert_equal @mock_client, @datastore.client
  end

  def test_api_schema_calls_listapi
    @mock_client.expects(:request).with(:get, :api, "/listapi").returns("obj" => "")
    @datastore.api_schema
  end

end
