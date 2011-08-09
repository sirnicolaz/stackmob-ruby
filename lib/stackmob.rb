require 'oauth'
require 'yajl'
require 'yaml'

require 'stackmob/client'
require 'stackmob/data_store'
require 'stackmob/push'
require 'stackmob/rack/simple_oauth_provider'


module StackMob
  def self.config
    @config ||= YAML.load_file("config/stackmob.yml")
  end
end
