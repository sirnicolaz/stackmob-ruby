require 'oauth'
require 'yajl'

module StackMob
  class Client        

    VALID_METHODS = [:get, :post, :put, :delete]

    class InvalidRequestMethod < ArgumentError; end # invalid HTTP Method/Verb is passed to the client
    class RequestError < RuntimeError; end # response with code other than 200 received
    class BadResponseBody < RuntimeError; end # Client receives response with invalid JSON    

    attr_accessor :app_name, :app_vsn

    def initialize(base_url, app_name, app_vsn, oauth_key, oauth_secret)
      self.app_name = app_name
      self.app_vsn = app_vsn

      create_oauth_client(oauth_key, oauth_secret, base_url)
    end

    def request(method, path)
      raise InvalidRequestMethod unless VALID_METHODS.include?(method)

      response = @oauth_client.send(method, full_path(path))      
      if response.code.to_i == 200
        parse_response(response)
      else
        raise RequestError
      end
    end

    def create_oauth_client(key, secret, url)
      @oauth_client = OAuth::AccessToken.new(OAuth::Consumer.new(key, secret, :site => url))
    end
    private :create_oauth_client

    def parse_response(r)
      Yajl::Parser.parse(r.body)
    rescue Yajl::ParseError
      raise BadResponseBody.new("#{r.body} is not valid JSON")
    end
    private :parse_response

    def full_path(requested_path)
      "/api/#{self.app_vsn}/#{self.app_name}/#{strip_prepending_slash(requested_path)}"
    end
    private :full_path

    def strip_prepending_slash(path)
      path.gsub(/^\//, "")
    end
    private :strip_prepending_slash

  end
end
