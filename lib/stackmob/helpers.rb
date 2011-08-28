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
  module Helpers
    def sm_datastore
      @sm_datastore ||= begin
                          client = StackMob::Client.new(sm_api_host, sm_app_name, StackMob.env, StackMob.key, StackMob.secret)
                          StackMob::DataStore.new(client)
                        end
    end
    
    def sm_push
      @sm_push ||= begin
                     client = StackMob::Client.new(sm_push_host, sm_app_name, StackMob.env, StackMob.key, StackMob.secret)
                     StackMob::Push.new(client)
                   end
    end
    
    def sm_api_host
      sm_normalize_host(sm_hostname_from_header_or_config('HTTP_X_STACKMOB_API'))
    end
    private :sm_api_host

    def sm_push_host
      sm_normalize_host(sm_hostname_from_header_or_config('HTTP_X_STACKMOB_PUSH'))
    end
    private :sm_push_host
    
    def sm_hostname_from_header_or_config(header_str)
      hostname = request.env[header_str]
      (hostname.nil? || hostname == "") ? StackMob.dev_url : [StackMob.client_name, hostname].join(".")
    end
    private :sm_hostname_from_header_or_config

    def sm_app_name
      StackMob.app_name
    end
    private :sm_app_name
    
    def sm_app_version
      (Rails.env.production?) ? StackMob::PRODUCTION : StackMob::SANDBOX
    end
    private :sm_app_version
    
    def sm_normalize_host(host_str)
      schemeless = host_str.gsub(/^https?:\/\//, "")
      "http://#{schemeless}"
    end
    private :sm_normalize_host

  end
end
