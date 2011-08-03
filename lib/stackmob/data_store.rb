module StackMob
  class DataStore      

    attr_accessor :client

    def initialize(cl)
      self.client = cl
    end

    def api_schema
      self.client.request(:get, :api, "/listapi")
    end

  end
end
