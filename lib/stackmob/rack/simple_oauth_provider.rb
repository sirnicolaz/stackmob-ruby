require 'oauth'
require 'oauth/request_proxy/rack_request'

module StackMob
  module Rack
    class SimpleOAuthProvider

      def initialize(app)
        @app = app
      end
      
      def call(env)
        request = ::Rack::Request.new(env)
        signature = OAuth::Signature.build(request, :token_secret => "", :consumer_secret => StackMob.secret)
        if signature.verify          
          @app.call(env)
        else
          not_authorized
        end       
      rescue OAuth::Signature::UnknownSignatureMethod
        not_authorized
      end
      
      def not_authorized
          [401, {}, "Not Authorized\n"]
      end
      private :not_authorized

    end
  end
end
