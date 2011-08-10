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
    StackMob.config[sm_env]['secret']
  end

  def self.sm_env
    (Rails.env.production?) ? "production" : "development"
  end

end
