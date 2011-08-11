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

require 'oauth'
require 'yajl'
require 'yaml'

require 'stackmob/client'
require 'stackmob/data_store'
require 'stackmob/push'
require 'stackmob/rack/simple_oauth_provider'
require 'stackmob/helpers'

module StackMob
  
  SANDBOX = 0
  PRODUCTION = 1
    
  def self.config
    @config ||= YAML.load_file("config/stackmob.yml")
  end
  
  def self.secret
    StackMob.config[sm_env_str]['secret']
  end

  def self.key
    StackMob.config[sm_env_str]['secret']
  end

  def self.app_name
    StackMob.config['sm_app_name']
  end

  def self.client_name
    StackMob.config['sm_client_name']
  end

  def self.env
    (is_production?) ? PRODUCTION : SANDBOX
  end

  def self.sm_env_str
    env == PRODUCTION ? "production" : "development"
  end

  def self.is_production?
    ENV["RACK_ENV"] == "production"
  end


end
