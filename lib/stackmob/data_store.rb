module StackMob
  class DataStore      

    attr_accessor :client

    API_SVC = :api

    def initialize(cl)
      self.client = cl
    end

    def api_schema
      self.client.request(:get, API_SVC, "/listapi")
    end

    def delete(obj_name, params)
      self.client.request(:delete, API_SVC, obj_name_to_path(obj_name), params)
    end

    def create(obj_name, params)
      self.client.request(:post, API_SVC, obj_name_to_path(obj_name), params)
    end

    def get(obj_name, params = {})
      self.client.request(:get, API_SVC, obj_name_to_path(obj_name), params)
    end

    def get_one(obj_name, params)
      get(obj_name, params).first
    end

    def update(obj_name, params)
      self.client.request(:put, API_SVC, obj_name_to_path(obj_name), params)
    end

    def obj_name_to_path(obj_name)
      "/#{obj_name}"
    end
    private :obj_name_to_path

  end
end
