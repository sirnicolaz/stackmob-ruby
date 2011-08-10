# Copyright 2011 StackMob
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

module StackMob
  class Push
    
    attr_accessor :client

    PUSH_SVC = :push
    DEVICE_TOKEN_PATH = "/device_tokens"
    BROADCAST_PATH = "/push_broadcast"
    PUSH_PATH = "/push"

    DEFAULT_BADGE = 0
    DEFAULT_SOUND = ""

    def initialize(cl)
      self.client = cl
    end

    def register(user_id, device_token)
      self.client.request(:post, PUSH_SVC, DEVICE_TOKEN_PATH, :userId => user_id, :token => device_token) # using non-convential symbols to conform to StackMob Push API
    end

    def broadcast(opts)
      aps_data = generate_aps_data(opts)
      payload = {:recipients => [], :aps => aps_data, :areRecipientsDeviceTokens => true, :exclude_tokens => []}

      self.client.request(:post, PUSH_SVC, BROADCAST_PATH, payload)
    end

    def send_message(to, opts)
      aps_data = generate_aps_data(opts)
      recipients_are_device_tokens = (opts[:recipients_are_users]) ? false : true
      payload = {:recipients => Array(to), :aps => aps_data, :areRecipientsDeviceTokens => recipients_are_device_tokens, :exclude_tokens => []}

      self.client.request(:post, PUSH_SVC, PUSH_PATH, payload)
    end

    def generate_aps_data(opts)
      alert = opts[:alert] || (raise ArgumentError.new("Push requires alert message"))
      badge = opts[:badge] || DEFAULT_BADGE
      sound = opts[:sound] || DEFAULT_SOUND
      
      {:badge => badge, :sound => sound, :alert => alert}
    end
    private :generate_aps_data

    

  end
end
