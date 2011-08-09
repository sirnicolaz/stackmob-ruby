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
