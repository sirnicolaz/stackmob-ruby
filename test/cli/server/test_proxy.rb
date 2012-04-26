require 'helper'

class ProxyTest < MiniTest::Unit::TestCase
  include TestHelpers

  def setup
    host! :local_server

    @files = write_files do |b|
      b.file ".stackmob", :config
    end

    launch_test_server do |env|
      if env['HTTP_X_TEST'] 
        [200, {}, ['{"header":true}']]
      elsif env['HTTP_X_STACKMOB_PROXY_PLAIN'] == 'stackmob-api'
        [200, {}, ['{"simpleproxy":true"}']]
      elsif env['HTTP_ACCEPT'] != "application/json"
        [200, {}, ["fail"]]
      elsif env['HTTP_AUTHORIZATION'] =~ /^OAuth/
        [200, {'X-Test-1' => "test", 'X-Test-2' => "test2"}, ['{"proxied":true}']]
      else
        [401, {}, ['{"error":"invalid oauth"}']]
      end
    end

    @start_dir = Dir.pwd
    Dir.chdir local
    ENV['STACKMOB_DEV_URL'] = "http://localhost:8080"
    run_cli "server"
  end

  def teardown
    shutdown_test_server
    kill!
    Dir.chdir @start_dir
    ENV.delete('STACKMOB_DEV_URL')
  end

  def test_proxies_request_with_header
    get "/abc", {}, {'X-StackMob-Proxy' => 'stackmob-api'}
    assert_responds_with 200, '{"proxied":true}'
  end

  def test_plain_proxy
    get "/plain", {}, {'X-StackMob-Proxy-Plain' => 'stackmob-api'}
    assert_responds_with 200, '{"simpleproxy":true"}'
  end


  def test_does_not_proxy_request_missing_header
    get "/abc"
    assert_responds_with 404
  end

  def test_proxies_request_headers
    get "/abc", {}, {'X-StackMob-Proxy' => 'stackmob-api', 'X-Test' => 'somevalue'}
    assert_responds_with 200, '{"header":true}'
  end

  def test_replaces_accept_request_header
    get "/abc", {}, {'X-StackMob-Proxy' => 'stackmob-api', 'Accept' => 'removeme'}
    assert_responds_with 200, '{"proxied":true}'
  end

  def test_proxies_response_headers
    post "/abc", "", {'X-StackMob-Proxy' => 'stackmob-api'}
    assert_succeeds_with_headers 'x-test-1' => 'test', 'x-test-2' => 'test2'
  end

end
