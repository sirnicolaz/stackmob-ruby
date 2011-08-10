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

require 'stackmob' 

module StackMob
  class Deployer
    
    attr_accessor :client

    APP_PATH = "heroku/app"

    def initialize(cl)
      self.client = cl
    end

    def register(hostname)
      self.client.request(:post, :api, APP_PATH, :hostname => hostname)
    end

    def fetch
      self.client.request(:get, :api, APP_PATH)
    end

  end
end
