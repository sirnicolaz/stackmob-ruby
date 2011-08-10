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

To fetch all records for an object use `StackMob::DatStore#get`: 

    >> datastore.get(:user)
	 => [{"username"=>"Some User", "lastmoddate"=>1312996693261, ...

Fetch a single record using `StackMob::DataStor#get_one`:
   
    >> datastore.get(:user, :username => "Some User")
	 => {"username"=>"Some User", "lastmoddate"=>1312996693261, ...
	 
    >> datastore.get(:user, :username => "D.N.E")
	 => nil
	 
Create and update records: 
   
    >> datastore.create(:user, :username => "newuser", :name => "First Last") # StackMob::DatStore#create will raise a StackMob::Client::RequestError if it fails
	 => nil	
	 
	>> datastore.update(:user, "newuser", :name => "New Name") # StackMob::DataStore#update will raise a StackMob::Client::RequestError if it fails	
	 => nil
	 
	 
Delete records

    >> datastore.delete(:user, :username => "newuser") # StackMob::DataStore#delete will raise a StackMob::Client::RequestError if it fails
     => nil
	 
## Interacting With Your API in Your Application

When you include `StackMob::ControllerMethods` in your `ApplicationController` you get a couple of convenience methods to use in your controller actions. `sm_datastore` and `sm_push` provide per-request instances of `StackMob::DataStore` & `StackMob::Push` (for more information on Push see "Sending Push Messages from your Application"). An example action, which returns a list of usernames for each user object record is below:

    class MyController < ApplicationController
	  
	  def username_list
		users = sm_datastore.get(:user)
		
		render :json => { :usernames => usernames.map { |u| u['username'] }
		
      rescue StackMob::Client::RequestError # something went wrong making the request
	    render :json => {"error": "could not communicate with StackMob Servers"}
      end
	  	
    end

### Sending Push Messages from your Application

`StackMob::Push` allows you to interact with the Push Notification portion of your StackMob API. The examples below show how to register a device token, send a message to a single user or device token and how to send a broadcast message to all users.

    # Register a User With His/Her Device Token in your Controller
	sm_push.register("user_id", "user_device_token")
	
	# Send a Push Message to a User using Device Token
	sm_push.send_message("user_device_token", :sound => "yoursoundfile.mp3", :alert => "The Message to Show the User", :badge => 2)
	
	# Send a Push Message to a User using the User Object's Primary Key
	sm_push.send_message("primary_key_value", :sound => "yoursendfile.mp3", :alert => "Message", :badge => 0, :recipients_are_users => true)
	
	# Broadcast a Message
	sm_push.broadcast(:badge => 1, :sound => "audiofile.mp3", :alert => "The Broadcasted Message")

Only the `:alert` key is required when sending or broadcasting messages. 

## Copyright

Copyright (c) 2011 StackMob. See LICENSE.txt for
further details
