require 'helper'

class StackMobPushTest < MiniTest::Unit::TestCase

  def setup
    @test_token = "abcdefghijklmnopqrstuv"    
    @user_id = "123"

    @mock_client = mock("StackMob::Client")
    @push = StackMob::Push.new(@mock_client)
  end

  def test_given_client_is_returned_client
    assert_equal @mock_client, @push.client
  end

  def test_register_call
    @mock_client.expects(:request).with(:post, :push, "/device_tokens", :userId => @user_id, :token => @test_token).returns(nil)
    @push.register(@user_id, @test_token)
  end

  def test_broadcast_call
    badge = 1,
    sound = "testsound.mp3"
    alert = "testing"

    expected_body = {:recipients => [], 
                     :aps => {:alert => alert, :sound => sound, :badge => badge}, 
                     :areRecipientsDeviceTokens => true,
                     :exclude_tokens => []}
    expected_params = [:post, :push, "/push_broadcast", expected_body]
    @mock_client.expects(:request).with(*expected_params).returns(nil)

    @push.broadcast(:badge => badge, :sound => sound, :alert => alert)
  end

  def test_broadcast_missing_alert_raises_error
    assert_raises ArgumentError do 
      @push.broadcast(:badge => 0, :sound => "") 
    end
  end

  def test_broadcast_badge_defaults_to_zero
    sound = "test.mp3"
    alert = "alert message"

    expected_body = {:recipients => [], 
                     :aps => {:alert => alert, :sound => sound, :badge => 0}, 
                     :areRecipientsDeviceTokens => true,
                     :exclude_tokens => []}
    expected_params = [:post, :push, "/push_broadcast", expected_body]
    @mock_client.expects(:request).with(*expected_params).returns(nil)
    @push.broadcast(:sound => sound, :alert => alert)
  end

  def test_broadcast_sound_defaults_to_empty_string
    badge = 1
    alert = "alert message"

    expected_body = {:recipients => [], 
                     :aps => {:alert => alert, :sound => "", :badge => badge}, 
                     :areRecipientsDeviceTokens => true,
                     :exclude_tokens => []}
    expected_params = [:post, :push, "/push_broadcast", expected_body]
    @mock_client.expects(:request).with(*expected_params).returns(nil)
    @push.broadcast(:badge => badge, :alert => alert)
  end

  def test_send_messsage_to_one_call
    sound = "testsound.mp3"
    alert = "Single Message"
    badge = 2
    token = "abc"

    expected_body = {:recipients => [token],
                     :aps => {:badge => badge, :sound => sound, :alert => alert},
                     :areRecipientsDeviceTokens => true,
                     :exclude_tokens => []}
    expected_params = [:post, :push, "/push", expected_body]
    @mock_client.expects(:request).with(*expected_params).returns(nil)
    @push.send_message(token, :alert => alert, :sound => sound, :badge => badge)
  end

  def test_send_message_without_alert_raises_error
    assert_raises ArgumentError do
      @push.send_message("avc", :sound => "somefile.mp3", :badge => 1)
    end
  end

  def test_send_message_defaults_badge_to_zero
    sound = "testsound.mp3"
    alert = "Single Message"
    token = "abc"

    expected_body = {:recipients => [token],
                     :aps => {:badge => 0, :sound => sound, :alert => alert},
                     :areRecipientsDeviceTokens => true,
                     :exclude_tokens => []}
    expected_params = [:post, :push, "/push", expected_body]
    @mock_client.expects(:request).with(*expected_params).returns(nil)
    @push.send_message(token, :alert => alert, :sound => sound)
  end

  def test_send_message_defaults_sound_to_empty_string
    alert = "Single Message"
    badge = 2
    token = "abc"

    expected_body = {:recipients => [token],
                     :aps => {:badge => badge, :sound => "", :alert => alert},
                     :areRecipientsDeviceTokens => true,
                     :exclude_tokens => []}
    expected_params = [:post, :push, "/push", expected_body]
    @mock_client.expects(:request).with(*expected_params).returns(nil)
    @push.send_message(token, :alert => alert, :badge => badge)
  end

  def test_send_message_with_user_ids
    sound = "testsound.mp3"
    alert = "Single Message"
    badge = 2
    token = "abc"

    expected_body = {:recipients => [token],
                     :aps => {:badge => badge, :sound => sound, :alert => alert},
                     :areRecipientsDeviceTokens => false,
                     :exclude_tokens => []}
    expected_params = [:post, :push, "/push", expected_body]
    @mock_client.expects(:request).with(*expected_params).returns(nil)
    @push.send_message(token, :alert => alert, :sound => sound, :badge => badge, :recipients_are_users => true)
  end

end
