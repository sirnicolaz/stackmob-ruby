require 'helper'

class StackMobPushTest < MiniTest::Unit::TestCase

  def setup
    @test_token = { "type" => "iOS", "token" => "abcdefghijklmnopqrstuv" }
    @user_id = "123"

    @mock_client = mock("StackMob::Client")
    @push = StackMob::Push.new(@mock_client)
  end

  def test_given_client_is_returned_client
    assert_equal @mock_client, @push.client
  end

  def test_register_call
    @mock_client.expects(:request).with(:post, :push, "/register_device_token_universal", :userId => @user_id, :token => @test_token).returns(nil)
    @push.register(@user_id, @test_token)
  end

  def test_remove_call
    @mock_client.expects(:request).with(:post, :push, "/remove_token_universal", @test_token).returns(nil)
    @push.remove(@test_token)
  end

  def test_broadcast_call
    badge = 1,
    sound = "testsound.mp3"
    alert = "testing"

    expected_body = { :kvPairs => {:alert => alert, :sound => sound, :badge => badge} }
    expected_params = [:post, :push, "/push_broadcast_universal", expected_body]
    @mock_client.expects(:request).with(*expected_params).returns(nil)

    @push.broadcast(:badge => badge, :sound => sound, :alert => alert)
  end

  def test_send_messsage_to_a_token
    message = "some message"
    android_token = { "type" => "android", "token" => "abc" }

    expected_body = {:tokens => [android_token],
      :payload => { :kvPairs => {:message => message}}}
    expected_params = [:post, :push, "/push_tokens_universal", expected_body]
    @mock_client.expects(:request).with(*expected_params).returns(nil)
    @push.send_message_to_tokens(android_token, :message => message)
  end

  def test_send_messsage_to_two_tokens
    sound = "testsound.mp3"
    alert = "Single Message"
    badge = 2
    other_message = "some message"
    android_token = { "type" => "android", "token" => "abc" }
    ios_token = { "type" => "ios", "token" => "def" }

    expected_body = {:tokens => [ios_token, android_token],
      :payload => { :kvPairs =>
        {:badge => badge, :audio => sound, :alert => alert,
          :other => other_message} }}
    expected_params = [:post, :push, "/push_tokens_universal", expected_body]
    @mock_client.expects(:request).with(*expected_params).returns(nil)
    @push.send_message_to_tokens([ios_token, android_token], :alert => alert, :audio => sound, :badge => badge, :other => other_message)
  end

  def test_send_messsage_with_an_user_id
    sound = "testsound.mp3"
    alert = "Single Message"
    badge = 2
    user = "abc"
    other_message = "some message"

    expected_body = {:userIds => [user],
      :kvPairs =>
        {:badge => badge, :audio => sound, :alert => alert,
          :other => other_message}}
    expected_params = [:post, :push, "/push_users_universal", expected_body]
    @mock_client.expects(:request).with(*expected_params).returns(nil)
    @push.send_message_to_users(user, :alert => alert, :audio => sound, :badge => badge, :other => other_message)
  end

end
