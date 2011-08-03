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

    def request(method, service, path, params = {})
      request_path, request_body = generate_path_and_body(method, service, path, params)

      response = @oauth_client.send(method, request_path, request_body)

      rcode = response.code.to_i
      if rcode >= 200 && rcode <= 299
        parse_response(response) if method == :get
      else
        raise RequestError
      end
    end

    def create_oauth_client(key, secret, url)
      @oauth_client = OAuth::AccessToken.new(OAuth::Consumer.new(key, secret, :site => url))
    end
    private :create_oauth_client

    def generate_path_and_body(method, service, path, params)
      intermediate_path = full_path(service, path)
      case method
      when :get, :delete
        [intermediate_path + "?" + params_to_qs(params), ""]
      when :post, :put
        [intermediate_path, Yajl::Encoder.encode(params)]
      else
        raise InvalidRequestMethod
      end
    end

    def params_to_qs(params)
      params.to_a.map { |pair| pair.join("=") }.join("&")
    end

    def parse_response(r)
      Yajl::Parser.parse(r.body)
    rescue Yajl::ParseError
      raise BadResponseBody.new("#{r.body} is not valid JSON")
    end
    private :parse_response

    def full_path(service, requested_path)
      "/#{service}/#{self.app_vsn}/#{self.app_name}/#{strip_prepending_slash(requested_path)}"
    end
    private :full_path

    def strip_prepending_slash(path)
      path.gsub(/^\//, "")
    end
    private :strip_prepending_slash

  end
end
