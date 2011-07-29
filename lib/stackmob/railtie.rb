require 'stackmob'
require 'rails'

module StackMob
  class Railtie < Rails::Railtie
    
    rake_tasks do
      load "stackmob/tasks.rb"
    end

  end
end
