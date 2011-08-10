require 'stackmob/deployer'

namespace :stackmob do

  desc "Notify StackMob of a New Deploy"
  task :deploy do

    app_name = StackMob.config['heroku_app_name']
    exit("No Heroku App Name Found in StackMob Config") if app_name.blank?
    exit("No Client Name Found in StackMob Config") if StackMob.client_name.blank?
    
    hostname = "#{app_name}.heroku.com"
    client = StackMob::Client.new("http://#{StackMob.client_name}.stackmob.com", StackMob.app_name, StackMob.env, StackMob.key, StackMob.secret)
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
