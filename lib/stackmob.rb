require 'oauth'
require 'yajl'
require 'yaml'

require 'stackmob/client'
require 'stackmob/data_store'
require 'stackmob/push'
require 'stackmob/rack/simple_oauth_provider'


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
    (Rails.env.production?) ? PRODUCTION : SANDBOX
  end

  def self.sm_env_str
    env == PRODUCTION ? "production" : "development"
  end

end
