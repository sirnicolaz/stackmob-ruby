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
require 'stackmob/cli/main'

module StackMob
  
  CONFIG_FILES = ["config/stackmob.yml",".stackmob"]

  class ConfigurationError < RuntimeError; end
    

  SANDBOX = 0
  PRODUCTION = 1
    
  def self.config
    @config ||= load_config(CONFIG_FILES.clone)

  end

  def self.load_config(filenames)
    YAML.load_file(filenames.shift)
  rescue Errno::ENOENT    
    if !filenames.empty? 
      load_config(filenames) 
    else
      raise ConfigurationError.new("Missing configuration file (#{CONFIG_FILES.join(' or ')})")
    end
  end
  
  def self.secret
    ENV[sm_env_key_str(:private_key)] || StackMob.config[sm_env_str]['secret']
  end

  def self.key
    ENV[sm_env_key_str(:public_key)] || StackMob.config[sm_env_str]['key']
  end

  def self.app_name
    ENV['STACKMOB_APP_NAME'] || StackMob.config['sm_app_name']
  end

  def self.client_name
    ENV['STACKMOB_CLIENT_NAME'] || StackMob.config['sm_client_name']
  end

  def self.dev_url    
    if env_url = ENV['STACKMOB_DEV_URL']
      env_url
    else
      cluster_name = (is_html5?) ?  "mob1" : "mob2"
      "http://#{StackMob.client_name}.#{cluster_name}.stackmob.com"
    end
  end

  def self.env
    (is_production?) ? PRODUCTION : SANDBOX
  end

  def self.sm_env_str
    env == PRODUCTION ? "production" : "development"
  end

  def self.is_html5?
    config['html5']
  end

  def self.is_production?
    ENV["RACK_ENV"] == "production"
  end

  def self.sm_env_key_str(suffix)
    "STACKMOB_" + ((is_production?) ? "PROD" : "SAND") + "_#{suffix.to_s.upcase}"
  end


end
