# stackmob-heroku

This gem is meant to be used along with the StackMob add-on for Heroku. Using this gem you can run your StackMob application's custom code on Heroku using Rails 3.

## Adding StackMob to your Rails 3 Application

Add the following to your Gemfile and run `bundle install`:

    gem "stackmob-heroku", :require => "stackmob/heroku"
    
## Configuring Your Application    
    
The gem requires a few configuration details that need to be added to the file `config/stackmob.yml`.

    # example config/stackmob.yml
    THERE SHOULD BE AN EXAMPLE FILE HERE & REALLY WE SHOULD GENERATE A BASE ONE FOR THEM TAKING KEYS AS INPUT
    
Additionally, you will want to include some helpful methods in your controllers. Add the line below to the `ApplicationController`. Check out "Interacting With Your API in Your Application" for more  details about the methods provided by StackMob::ControllerMethods.

    include StackMob::ControllerMethods 

## Interacting with CRUD from the Console

Once the gem is added to your application & configured you can take things for a test drive. You'll need to grab your public & private sandbox keys from the StackMob add-on page within the Heroku dashboard. Once you have those run `rails console`. All of the classes you will use in your application function using a class called `StackMob::Client`. You will not be exposed to this class in your controllers but to test in the console you will need to create an instance:

    >> stackmob_client = StackMob::Client.new("http://yoursubdomain.stackmob.com/", "your_application_name", 0, "your_public_key", "your_private_key")
     => #<StackMob::Client:0x007fae99839cb8 @app_name= ...>
    
Although you can use the `StackMob::Client` to interact with the CRUD methods of your API, you will be using `StackMob::DataStore` in your application, which provides a much simpler interface to perform operations.

    >> datastore = StackMob::DataStore.new(stackmob_client)
     => #<StackMob::DataStore:0x007fae991eebd8 ...>

The simplest operation to perform is to list the application's schema:

    >> datastore.api_schema
     => {"user"=>{"properties"=>{"username"=> ...

    NEED GET/CREATE/UPDATE/DELETE examples    

## Interacting With Your API in Your Application

    NEED EXAMPLES OF USING sm_datastore & sm_push inside controllers

## Copyright

Copyright (c) 2011 StackMob. See LICENSE.txt for
further details
