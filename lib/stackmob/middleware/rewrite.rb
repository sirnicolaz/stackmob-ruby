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

module StackMob
  module Middleware
    class Rewrite
      def initialize(app)
        @app = app
      end
      
      def call(env)
        status, hdrs, body = @app.call(env)
        original_response = [status, hdrs, body]

        if status == 404
          path_info        = env['PATH_INFO']
          env['PATH_INFO'] = "#{path_info}/index.html".gsub('//', '/')

          
          status, hdrs, body = @app.call(env)
          
          if status == 404
            env['PATH_INFO'] = "/404.html"
            
            status, hdrs, body = @app.call(env)
            
            if status == 404
              status, hdrs, body = original_response
            else
              status = 404
            end
          end
        end
        
        [ status, hdrs, body ]
      end
    end
  end
end
