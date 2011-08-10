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

require 'stackmob'
require 'rails'

module StackMob
  class Railtie < Rails::Railtie        

    rake_tasks do
      load "stackmob/tasks.rb"
    end

    initializer "warn of missing config file" do
      config.after_initialize do
        unless Rails.root.join("config", "stackmob.yml").file?
          puts "\nStackmob Config (config/stackmob.yml) not found\n"
        end
      end
    end

    initializer "setup middleware" do |app|
      app.config.middleware.use StackMob::Rack::SimpleOAuthProvider
    end

  end
end
