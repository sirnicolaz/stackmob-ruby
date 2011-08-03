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

  def test_delete_call
    uid = "abc"

    @mock_client.expects(:request).with(:delete, :api, "/user", :user_id => uid).returns(nil)
    @datastore.delete(:user, :user_id => uid)
  end

  def test_create_call
    name = "test user"

    @mock_client.expects(:request).with(:post, :api, "/user", :name => name).returns(nil)
    @datastore.create(:user, :name => name)
  end
  
  def test_get_all_call
    @mock_client.expects(:request).with(:get, :api, "/user", Hash.new).returns(nil)
    @datastore.get(:user)
  end

  def test_update_call
    uid = "abc"
    name = "test user"
    params = {:user_name  => uid, :name => name}

    @mock_client.expects(:request).with(:put, :api, "/user", params).returns(nil)
    @datastore.update(:user, params)
  end  

end
