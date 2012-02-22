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
    DEVICE_TOKEN_PATH = "/register_device_token_universal"
    REMOVE_DEVICE_TOKEN = "/remove_token_universal"
    BROADCAST_PATH = "/push_broadcast_universal"
    PUSH_TOKENS_PATH = "/push_tokens_universal"
    PUSH_USERS_PATH = "/push_users_universal"

    DEFAULT_BADGE = 0
    DEFAULT_SOUND = ""

    def initialize(cl)
      self.client = cl
    end

    def register(user_id, device_token)
      self.client.request(:post, PUSH_SVC, DEVICE_TOKEN_PATH, :userId => user_id, :token => device_token) # using non-convential symbols to conform to StackMob Push API
    end

    def remove(device_token)
      self.client.request(:post, PUSH_SVC, REMOVE_DEVICE_TOKEN, device_token)
    end

    def broadcast(opts)
      payload = { :kvPairs => opts }
      self.client.request(:post, PUSH_SVC, BROADCAST_PATH, payload)
    end

    def aps_data(opts)
      alert = opts[:alert] || (raise ArgumentError.new("Push requires alert message"))
      badge = opts[:badge] || DEFAULT_BADGE
      sound = opts[:sound] || DEFAULT_SOUND
      
      {:badge => badge, :sound => sound, :alert => alert}
    end

    # Deprecated
    def send_message(to, opts)
      warn "[DEPRECATION] `send_message` is deprecated and does not support android, please use `send_message_to_tokens` or `send_message_to_users`"
      recipients_are_device_tokens = (opts[:recipients_are_users]) ? false : true
      payload = {:recipients => Array(to), :aps => aps_data(opts), :areRecipientsDeviceTokens => recipients_are_device_tokens, :exclude_tokens => []}

      self.client.request(:post, PUSH_SVC, "/push", payload)
    end

    def send_message_to_tokens(to, opts)
      to = [to] if to.is_a? Hash
      payload = {:tokens => Array(to), :payload => { :kvPairs => opts }}
      self.client.request(:post, PUSH_SVC, PUSH_TOKENS_PATH, payload)
    end

    def send_message_to_users(to, opts)
      payload = {:userIds => Array(to), :kvPairs => opts}
      self.client.request(:post, PUSH_SVC, PUSH_USERS_PATH, payload)
    end
  end

end
