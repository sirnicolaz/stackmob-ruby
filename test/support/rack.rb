require 'uri'
require 'rack'
require 'httpclient'
require 'webrick'
require 'webrick/ssl'
require 'webrick/https'
require 'socket'

Thread.abort_on_exception = true

module TestHelpers
  class TestServer
    include Utils
    
    DEFAULT_PORT = 8080
    attr_reader :app, :options
    
    def initialize(app, options = {})
      @app, @options = app, options
      @server = nil
    end

    def start
      if ssl?
        certificate, private_key = WEBrick::Utils.create_self_signed_cert(1024, [["CN", WEBrick::Utils.getservername]], "comment?!?")
      end

      port = options[:port] || DEFAULT_PORT

      @server = ::WEBrick::HTTPServer.new(
        :Host            => '0.0.0.0',
        :Port            => port,
        :Logger          => logger,
        :AccessLog       => [],
        :SSLEnable       => ssl?,
        :SSLCertificate  => certificate,
        :SSLPrivateKey   => private_key,
        :SSLVerifyClient => OpenSSL::SSL::VERIFY_NONE,
        :SSLCertName     => [["CN", WEBrick::Utils.getservername]])
      
      @server.mount "/", TestServlet, app

      yield @server if block_given?

      Thread.new do
        @server.start
      end

      wait_for_local_server(port)
    end

    def stop
      @server.shutdown if @server
    end

    private

    def ssl?
      options[:ssl]
    end
    
    def logger
      @logger ||= WEBrick::Log.new(nil, WEBrick::BasicLog::WARN)
    end

  end

  class TestServlet < WEBrick::HTTPServlet::AbstractServlet
    
    def initialize(server, app)
      super server
      @app = Rack::ContentLength.new(app)
    end
    
    def service(req, res)
      env = req.meta_vars
      env.delete_if { |k, v| v.nil? }
      
      rack_input = StringIO.new(req.body.to_s)
      rack_input.set_encoding(Encoding::BINARY) if rack_input.respond_to?(:set_encoding)

      env.update({"rack.version" => Rack::VERSION,
                   "rack.input" => rack_input,
                   "rack.errors" => $stderr,

                   "rack.multithread" => true,
                   "rack.multiprocess" => false,
                   "rack.run_once" => false,

                   "rack.url_scheme" => ["yes", "on", "1"].include?(ENV["HTTPS"]) ? "https" : "http"
                 })

      env["HTTP_VERSION"] ||= env["SERVER_PROTOCOL"]
      env["QUERY_STRING"] ||= ""
      env["REQUEST_PATH"] ||= "/"
      unless env["PATH_INFO"] == ""
        path, n = req.request_uri.path, env["SCRIPT_NAME"].length
        env["PATH_INFO"] = path[n, path.length-n]
      end

      status, headers, body = @app.call(env)

      begin
        res.status = status.to_i
        headers.each { |k, vs|
          if k.downcase == "set-cookie"
            res.cookies.concat vs.split("\n")
          else
            if k.downcase == 'transfer-encoding' && vs == 'chunked'
              res.chunked = true
            end
            vs.split("\n").each { |v|
              res[k] = v
            }
          end
        }
        body.each { |part|
          res.body << part
        }
      ensure
        body.close  if body.respond_to? :close
      end
    end
  end

  def launch_test_server(opts = {}, &callback)
    shutdown_test_server
    
    app = lambda do |env|
      if callback && res = callback.call(env)
        res
      else
        hdrs = {'Content-Type' => 'text/plain'}
        ret  = env.slice(*RACK_ENV_KEYS)
        
        ret['rack.input'] = ret['rack.input'].read if ret['rack.input']
        
        [ 200, hdrs, [ret.inspect] ]
      end
    end
    
    @server = TestServer.new(app, opts)
    @server.start
  end
  
  def shutdown_test_server
    @server.stop if @server
    @server = nil
  end
  
  %w( get post put delete head ).each do |method|
    class_eval <<-RUBY
      def #{method}(uri, *args)
        request(:#{method}, uri, *args)
      end
    RUBY
  end
  
  attr_reader :response
  attr_reader :host

  def host!(h)
    h = "localhost:#{StackMob::CLI::LocalServer::DEFAULT_PORT}" if h == :local_server
    @host = h
  end
  
  def request(method, path, *args)
    path = path[1..path.length] if path[0] == "/" 
    @client ||= HTTPClient.new
    @response = @client.send(method, "http://#{host}/#{path}", *args)
  end

  
  def assert_responds_with(status, body = nil, hdrs = {})
    assert_equal status, @response.status
    assert_equal body, @response.body if body    
    hdrs.each do |hdr, val|
      assert_equal val, @response.headers[hdr], "header: #{hdr} expected: #{val} actually: #{@response.headers[hdr]}"
    end
  end
  
  def assert_succeeds_with_headers(env)
    assert_equal 200, @response.status
    env.each do |key, val|
      assert_equal val, @response.headers[key]
    end    
  end

end
