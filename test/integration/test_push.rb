require 'integration_helper'

class PushIntegrationTest < StackMobIntegrationTest
  
  def setup
    super

    @user_id = "push_user"    
    @device_token = { :type => "iOS", :token => "1b9cc1e947889c47f83bab981f0b5349a38903578c40cca519b1c22796c5eadf" }

    @push = StackMob::Push.new(valid_client)
  end

  def test_register_broadcast_push
    @push.remove(@device_token)

    @push.register(@user_id, @device_token)

    @push.broadcast(:badge => 1, :sound => "audiofile.mpg", :alert => "My Push Message to all")   

    @push.send_message(@user_id, :sound => "anotherfile.mpg", :alert => "Ruby Gem Says: hi #{@user_id}", :badge => 2)

    @push.send_message(@device_token, :alert => "Ruby Gem: This is a message for token: #{@device_token}")
  end

end
