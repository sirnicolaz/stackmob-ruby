# StackMob

This gem is meant to be used along with the StackMob add-on for Heroku. Using this gem you can extend your StackMob REST API using a Rails 3 or Sinatra application (Rails 2.3.x Support Coming Soon) deployed on Heroku. 

When you deploy your application your routes will become available via the production version of your StackMob API. StackMob will proxy any API call of the form `http://[SUBDOMAIN].mob2.stackmob.com/api/[VERSION]/[APPNAME]/heroku/proxy/[ROUTE]` to your Heroku application. 

## Adding StackMob to your Rails 3 Application

Add the following to your Gemfile and run `bundle install`:

    gem "stackmob", :require => "stackmob/rails"
	
Additionally, you will want to include some helpful methods in your controllers. Add the line below to the `ApplicationController`. Check out "Interacting With Your API in Your Application" for more  details about the methods provided by StackMob::Helpers.

    include StackMob::Helpers 
	    
## Configuring Your Application (For Local Development)

This section only pertains to setting up your Rails or Sinatra application for development & testing. If you wish solely to deploy to Heroku you can skip this section. 
    
For local development, a few configuration details need to be set in the file `config/stackmob.yml`. You will need your subdomain, the name of the application you created, as well as your public and private keys for both development (sandbox) and production from the StackMob add-on dashboard. When specifying your Heroku hostname, if your application is available under the herokuapp.com domain as well as heroku.com, use the herokuapp.com domain otherwise, use heroku.com. 

    # example config/stackmob.yml
	sm_app_name: StackMob App Name
	sm_client_name: Your StackMob Client Name
    heroku_hostname: Full Hostname of Your Heroku Application (e.g. my-app.herokuapp.com)

    development:	
      key: Your StackMob Sandbox Public Key
      secret: Your StackMob Sandbox Private Key

    production:	
      key: Your StackMob Production Public Key
      secret: Your StackMob Production Private Key
    	
The railtie provided with this gem adds a simple oauth provider into the middleware stack. When making requests to your Rails or Sinatra application while its running locally you can either use the oauth gem, installed as a dependency to this one, with your public/private development keys in `config/stackmob.yml` or add the line `no_oauth: true` under the development section of the same config file. Adding the `no_oauth: true` line to `config/stackmob.yml` will only prevent verification of oauth keys locally. It will not turn off the middleware in production even if the option is specified under the production section of the config file. 

## Interacting with CRUD from the Console

Once the gem is added to your application & configured you can take things for a test drive. You'll need to grab your public & private sandbox keys from the StackMob add-on page within the Heroku dashboard. Once you have those run `rails console`. All of the classes you will use in your application function using a class called `StackMob::Client`. You will not be exposed to this class in your controllers but to test in the console you will need to create an instance:

    >> stackmob_client = StackMob::Client.new(StackMob.dev_url, StackMob.app_name, StackMob::SANDBOX, StackMob.key, StackMob.secret)
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

Fetch a single record using `StackMob::DataStore#get_one`:
   
    >> datastore.get_one(:user, :username => "Some User")
	 => {"username"=>"Some User", "lastmoddate"=>1312996693261, ...
	 
    >> datastore.get_one(:user, :username => "D.N.E")
	 => nil
	 
Create and update records: 
   
    >> datastore.create(:user, :username => "newuser", :name => "First Last") 
	 => true	
	 
	>> datastore.update(:user, "newuser", :name => "New Name") 
	 => true
	 
	 
Delete records

    >> datastore.delete(:user, :username => "newuser")
     => true
	 
## Interacting With Your API in Your Application

When you include `StackMob::Helpers` in your `ApplicationController` you get a couple of convenience methods to use in your controller actions. `sm_datastore` and `sm_push` provide per-request instances of `StackMob::DataStore` & `StackMob::Push` (for more information on Push see "Sending Push Messages from your Application"). An example action, which returns a list of usernames for each user object record is below:

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

## Using Sinatra

You can also write your application using Sinatra. Create a Gemfile like the one below and run `bundle install`. You also need to create a `config/stackmob.yml` like the one above.

    source 'http://rubygems.org'
	
	gem 'sinatra'
	gem 'stackmob', :require => 'stackmob/sinatra'
	
In your `config.ru` file add the following line:

    use StackMob::Rack::SimpleOAuthProvider
	
To use the `StackMob::Helpers` module in a classic Sinatra application:

    require 'bundler/setup'

	require 'sinatra'
	require 'stackmob/sinatra'
	
	before do
	  content_type :json # your responses should always return a JSON content type
    end
	
	...
	
To use it in a modular application:

    require 'bundler/setup'
	
    require 'sinatra/base'
	require 'stackmob/sinatra'
	
	class MyApp < Sinatra::Base
	  helpers StackMob::Helpers
	  
	  ...
	  
    end
	
### Adding Rake Tasks to a Sinatra Application

Add the following lines to your Rakefile in order to add the `stackmob:deploy` task. 

	require 'bundler/setup' # add this line if its not already included in your Rakefile
	require 'stackmob/tasks'

## Deploying

In order to deploy your Rails application you will first need to deploy your StackMob API to production. To do so, go to the StackMob add-on page, click the deploy tab, and select "Deploy to Live API". Once on the deployment page, select "Create from Sandbox" for which snapshot to deploy and "API Version 1" for which version to deploy to. Add any comments in the deploy notes field and click deploy. 

Deploying your Heroku application only requires one additional step. After you have pushed your changes to Heroku you will need to run:

    heroku run rake stackmob:deploy
	
This rake task will inform the StackMob servers that you have deployed a new version of your application as well as update any information that may be needed to proxy requests to your application.

Once your API & Application are deployed, you can, of course, start using it with the [StackMob iOS SDK](https://github.com/stackmob/StackMob_iOS) but if you would like to take things for a test drive, you can also use `StackMob::Client`. Create a client to use your production keys like the example below:

    client = StackMob::Client.new(StackMob.dev_url, StackMob.app_name, StackMob::PRODUCTION, StackMob.config['production']['key'], StackMob.config['production']['secret'])

You can then proxy requests to your application using the `StackMob::Client#request`:

    client.request(:get, :api, "heroku/proxy/path/to/proxy/to")

## Running your Application Locally in Development



## Contributing to stackmob gem

The stackmob Ruby Gem is Apache 2.0 licensed (see LICENSE.txt) and we look forward to your contributions. 

### Reporting Bugs

We are using [GitHub Issues](https://github.com/stackmob/stackmob-ruby/issues) to track feature requests and bugs.

### Running the Tests

Before submitting a pull request add any appropriate tests and run them along with the existing ones. The gem includes tasks to run unit & integration tests seperately or together. Before running the integration tests you will need to setup a few things. First, create a new application on your StackMob account named "test". In the new application, create a User Object named "user", with one extra string field, "name". Finally, you will have to set a few environment variables. If your using RVM, a good place to put these is your .rvmrc file.

    export STACKMOB_TEST_URL="YOURDOMAIN.stackmob.com"
    export STACKMOB_TEST_KEY="YOUR TEST APP PUB KEY"
    export STACKMOB_TEST_SECRET="YOUR TEST APP PRIV KEY"
    
You can run the tests with one of these three Rake tasks:

    rake test:all
    rake test:unit
    rake test:integration

## Copyright

Copyright 2011 StackMob

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.


