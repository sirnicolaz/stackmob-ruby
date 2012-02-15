# Copyright 2012 StackMob
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

require 'rack'
require 'stackmob/middleware/rewrite'
require 'stackmob/middleware/proxy'

begin
  require 'thin/version'

  module Thin::VERSION
    # Censoring
    if CODENAME == "Bat-Shit Crazy"
      remove_const :CODENAME
      CODENAME = "Rockhead Slate"
    end
  end
rescue LoadError
end

module StackMob
  module CLI
    module LocalServer
      DEFAULT_PORT = 4567

      class Server < ::Rack::Server
        def app
          options[:app]
        end      
      end
      
      def start_local_server(port = DEFAULT_PORT, path_root = '.')
        app = ::Rack::Builder.new do 
          use StackMob::Middleware::Proxy
          use StackMob::Middleware::Rewrite

          endpoint = ::Rack::Static.new lambda { |e| [] }, :urls => ['/'], :root => path_root
          map "/" do 
            run endpoint
          end
        end.to_app        
        Server.start :app => app, :host => '0.0.0.0', :server => 'thin', :Port => port
      end
      
    end
  end
end


