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


require 'thor'
require 'stackmob/cli/local_server'

module StackMob
  module CLI    
    class Main < Thor
      include LocalServer

      method_option "port", :type => :string, :banner => "port to start server on", :aliases => "-p", :default => "4567"
      method_option "path", :type => :string, :banner => "root directory to serve files from", :default => "."
      desc "server", "start test server"
      def server
        start_local_server(options[:port], options[:path])
      end

    end
  end
end
