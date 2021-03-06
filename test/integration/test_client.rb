require 'integration_helper'

# this test suite assumes that the Sandbox API 
# deployed at ENV['STACKMOB_TEST_URL'] has an object
# model created of type "user", with a single string field
# "name". The application name must be "test"

class ClientIntegrationTest < StackMobIntegrationTest

  def setup
    super
  end

  def test_valid_get_path
    api_result_hash = valid_client.request(:get, :api, "/listapi")
    assert api_result_hash.has_key?("user")
  end

  def test_get_path_without_prepending_slash
    res = valid_client.request(:get, :api, "listapi")
    assert res.has_key?("user")
  end

  def test_invalid_get_path_raises_error
    assert_raises StackMob::Client::RequestError do 
      valid_client.request(:get, :api, "/dne")
    end
  end

  def test_user_object_lifecycle
    username = "123"
    name = "StackMob Test"

    valid_client.request(:delete, :api, "/user", :username => username) # delete the object in case it exists already

    valid_client.request(:post, :api, "/user", :username => username, :name => name)

    assert_equal name, valid_client.request(:get, :api, "/user", :username => username).first['name']
    
    valid_client.request(:put, :api, "/user", :username => username, :name => name + "updated")
    
    assert_equal (name + "updated"), valid_client.request(:get, :api, "/user", :username => username).first['name']
  end

end
