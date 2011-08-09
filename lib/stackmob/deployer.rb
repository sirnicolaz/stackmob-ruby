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
