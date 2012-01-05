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

require 'stackmob/deployer'

namespace :stackmob do

  desc "Notify StackMob of a New Deploy"
  task :deploy do

    abort("No Client Name Found in StackMob Config") if StackMob.client_name.blank?
    abort("No Heroku App Name or Hostname Found in StackMob Config") if StackMob.config['heroku_app_name'].to_s.blank? && StackMob.config['heroku_hostname'].to_s.blank?

    hostname = StackMob.config['heroku_hostname'] || "#{StackMob.config['heroku_app_name']}.herokuapp.com"
    client = StackMob::Client.new("http://#{StackMob.client_name}.mob2.stackmob.com", StackMob.app_name, StackMob::SANDBOX, StackMob.config['development']['key'], StackMob.config['development']['secret'])
    deployer = StackMob::Deployer.new(client)

    begin
      deployer.register(hostname)
    
      puts "Registered"
      puts deployer.fetch
    rescue StackMob::Client::RequestError
      puts "Failed to register application. Unable to Communicate with stackmob.com or Authenticate. Please check your keys in config/stackmob.yml and try again"
    end
  end

end
