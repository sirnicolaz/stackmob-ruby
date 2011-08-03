require 'integration_helper'

class DataStoreIntegrationTest < StackMobIntegrationTest

  def setup
    super

    @ds = StackMob::DataStore.new(valid_client)
  end

  def test_list_api
    assert @ds.api_schema.has_key? "user"
  end

end
