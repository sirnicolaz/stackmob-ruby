require 'helper'

class StackMobTestCase < MiniTest::Unit::TestCase

  def setup
    @config_dev_key = "config_dev_key"
    @config_dev_secret = "config_dev_secret"
    @config_prod_key = "config_prod_key"
    @config_prod_secret = "config_prod_secret"
    @config_app_name = "config_app_name"
    @config_client_name = "config_client_name"

    @env_dev_key = "env_dev_key"
    @env_dev_secret = "env_dev_secret"
    @env_prod_key = "env_prod_key"
    @env_prod_secret = "env_prod_secret"
    @env_app_name = "env_app_name"
    @env_client_name = "env_client_name"

    StackMob.stubs(:config).returns("sm_client_name" => @config_client_name, "sm_app_name" => @config_app_name, 
                                    "development" => {"key" => @config_dev_key, "secret" => @config_dev_secret}, "production" => {"key" => @config_prod_key, "secret" => @config_prod_secret})
  end

  def test_fetch_app_name_when_no_env_key_exists
    assert_equal @config_app_name, StackMob.app_name
  end

  def test_fetch_app_name_when_env_key_exists
    ENV["STACKMOB_APP_NAME"] = @env_app_name

    assert_equal @env_app_name, StackMob.app_name

    ENV["STACKMOB_APP_NAME"] = nil
  end

  def test_fetch_client_name_when_no_env_key_exists
    assert_equal @config_client_name, StackMob.client_name
  end

  def test_fetch_client_name_when_env_key_exists
    ENV["STACKMOB_CLIENT_NAME"] = @env_client_name

    assert_equal @env_client_name, StackMob.client_name

    ENV["STACKMOB_CLIENT_NAME"] = nil
  end

  def test_fetch_dev_key_when_no_env_key_exists
    previous_rack_env = ENV["RACK_ENV"]
    ENV["RACK_ENV"] = "development"
    
    assert_equal @config_dev_key, StackMob.key

    ENV["RACK_ENV"] = previous_rack_env
  end

  def test_fetch_dev_secret_when_no_env_secret_exists
    previous_rack_env = ENV["RACK_ENV"]
    ENV["RACK_ENV"] = "development"

    assert_equal @config_dev_secret, StackMob.secret

    ENV["RACK_ENV"] = previous_rack_env
  end

  def test_fetch_prod_key_when_no_env_key_exists
    previous_rack_env = ENV["RACK_ENV"]
    ENV["RACK_ENV"] = "production"
    
    assert_equal @config_prod_key, StackMob.key

    ENV["RACK_ENV"] = previous_rack_env
  end

  def test_fetch_prod_secret_when_no_env_secret_exists
    previous_rack_env = ENV["RACK_ENV"]
    ENV["RACK_ENV"] = "production"

    assert_equal @config_prod_secret, StackMob.secret

    ENV["RACK_ENV"] = previous_rack_env
  end

  def test_fetches_dev_key_from_env_when_exists
    previous_rack_env = ENV["RACK_ENV"]
    ENV["RACK_ENV"] = "development"
    ENV["STACKMOB_SAND_PUBLIC_KEY"] = @env_dev_key

    assert_equal @env_dev_key, StackMob.key
    
    ENV["STACKMOB_SAND_PUBLIC_KEY"] = nil
    ENV["RACK_ENV"] = previous_rack_env
  end

  def test_fetches_dev_secret_from_env_when_exists
    previous_rack_env = ENV["RACK_ENV"]
    ENV["RACK_ENV"] = "development"
    ENV["STACKMOB_SAND_PRIVATE_KEY"] = @env_dev_secret

    assert_equal @env_dev_secret, StackMob.secret

    ENV["STACKMOB_SAND_PRIVATE_KEY"] = nil
    ENV["RACK_ENV"] = previous_rack_env
  end

  def test_fetches_prod_key_from_env_when_exists
    previous_rack_env = ENV["RACK_ENV"]
    ENV["RACK_ENV"] = "production"
    ENV["STACKMOB_PROD_PUBLIC_KEY"] = @env_prod_key
    
    assert_equal @env_prod_key, StackMob.key

    ENV["RACK_ENV"] = previous_rack_env
    ENV["STACKMOB_PROD_PUBLIC_KEY"] = nil
  end

  def test_fetches_prod_secret_from_env_when_exists
    previous_rack_env = ENV["RACK_ENV"]
    ENV["RACK_ENV"] = "production"
    ENV["STACKMOB_PROD_PRIVATE_KEY"] = @env_prod_secret
    
    assert_equal @env_prod_secret, StackMob.secret

    ENV["RACK_ENV"] = previous_rack_env
    ENV["STACKMOB_PROD_PRIVATE_KEY"] = nil
  end


end
