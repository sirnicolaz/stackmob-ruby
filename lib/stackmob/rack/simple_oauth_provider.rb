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
require 'oauth/request_proxy/rack_request'

module StackMob
  module Rack
    class SimpleOAuthProvider

      def initialize(app)
        @app = app
      end
      
      def call(env)
        request = ::Rack::Request.new(env)
        signature = OAuth::Signature.build(request, :token_secret => "", :consumer_secret => StackMob.secret)
        if signature.verify          
          @app.call(env)
        else
          not_authorized
        end       
      rescue OAuth::Signature::UnknownSignatureMethod
        not_authorized
      end
      
      def not_authorized
          [401, {}, "Not Authorized\n"]
      end
      private :not_authorized

    end
  end
end
