require 'integration_helper'

class DataStoreIntegrationTest < StackMobIntegrationTest

  def setup
    super

    @ds = StackMob::DataStore.new(valid_client)
  end

  def test_list_api
    assert @ds.api_schema.has_key? "user"
  end

  def test_user_object_lifecycle
    username = "456"
    name = "StackMob Test"
    updated_name = "updated name"

    @ds.delete(:user, :username => username)

    @ds.create(:user, :username => username, :name => name)

    assert_equal name, @ds.get(:user, :username => username).first['name']

    @ds.update(:user, username, :name => updated_name)

    assert_equal updated_name, @ds.get_one(:user, :username => username)['name']
  end

end
