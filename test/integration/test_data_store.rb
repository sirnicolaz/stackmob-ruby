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
    user_id = "456"
    user_name = "StackMob Test"
    updated_name = "updated name"

    @ds.delete(:user, :user_id => user_id)

    @ds.create(:user, :user_id => user_id, :name => user_name)

    assert_equal user_name, @ds.get(:user, :user_id => user_id).first['name']

    @ds.update(:user, :user_id => user_id, :name => updated_name)

    assert_equal updated_name, @ds.get_one(:user, :user_id => user_id)['name']
  end

end
