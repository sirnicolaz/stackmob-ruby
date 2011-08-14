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
  class DataStore      

    attr_accessor :client

    API_SVC = :api

    def initialize(cl)
      self.client = cl
    end

    def api_schema
      self.client.request(:get, API_SVC, "/listapi")
    end
    
    def create(obj_name, params)
      create!(obj_name, params)
    rescue Client::RequestError
      false
    end

    def create!(obj_name, params)
      self.client.request(:post, API_SVC, obj_name_to_path(obj_name), params)
    end

    def delete(obj_name, params)
      delete!(obj_name, params); true
    rescue Client::RequestError
      false
    end

    def delete!(obj_name, params)
      self.client.request(:delete, API_SVC, obj_name_to_path(obj_name), params)
    end

    def get(obj_name, params = {})
      self.client.request(:get, API_SVC, obj_name_to_path(obj_name), params)
    end

    def get_one(obj_name, params)
      get(obj_name, params).first
    end

    def update(obj_name, obj_id, params)
      update!(obj_name, obj_id, params); true
    rescue Client::RequestError
      false
    end

    def update!(obj_name, obj_id, params)
      self.client.request(:put, API_SVC, obj_name_to_path(obj_name) + "/#{obj_id}", params)
    end

    def obj_name_to_path(obj_name)
      "/#{obj_name}"
    end
    private :obj_name_to_path

  end
end
