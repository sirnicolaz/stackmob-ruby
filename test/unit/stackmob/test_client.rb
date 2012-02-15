require 'helper'

class StackmobClientTest < MiniTest::Unit::TestCase 
  
  attr_reader :valid_client

  def app_name
    "test"
  end

  def app_vsn
    0
  end

  def test_params
    {:abc => 123, :def => 456}
  end

  def stub_all_requests(method, resp_obj)
    OAuth::AccessToken.any_instance.stubs(method).returns(resp_obj)    
  end  

  def setup
    @valid_client = StackMob::Client.new("http://123.com/", app_name, app_vsn, "some-valid-test-key", "some-valid-test-secret")
    @test_hash = {"a" => 1, "b" => 2}
    @good_resp = mock("Net::HTTPResponse")
    @good_resp.stubs(:code).returns(200)
    @good_resp.stubs(:body).returns(Yajl::Encoder.encode(@test_hash))                                 

    # hack to give test suite access to underlying oauth object
    class << valid_client
      def _oauth
        @oauth_client
      end
    end
  end

  def test_response_json_parsed
    stub_all_requests(:get, @good_resp)

    assert_equal @test_hash, valid_client.request(:get, :some_service, "/abc")
  end

  def test_requesting_invalid_method_raises_error
    assert_raises StackMob::Client::InvalidRequestMethod do
      valid_client.request(:invalid, :some_service, "/asd")
    end
  end

  def test_when_resp_code_is_not_200
    failed = mock("Net::HTTPResponse")
    failed.stubs(:code).returns(404)
    stub_all_requests(:get, failed)

    
    assert_raises StackMob::Client::RequestError do
      valid_client.request(:get, :some_service, "/asd")
    end
  end

  def test_when_json_parsing_will_raise_an_error
    resp_w_invalid_body = mock("Net::HTTPResponse")
    resp_w_invalid_body.stubs(:code).returns(200)
    resp_w_invalid_body.stubs(:body).returns("this is not valid json")
    stub_all_requests(:get, resp_w_invalid_body)

    assert_raises StackMob::Client::BadResponseBody do
      valid_client.request(:get, :some_service, "/asd")
    end
  end

  def test_get_with_request_params
    service = :some_service
    path = "user"

    valid_client._oauth.expects(:get).with("/#{service}/#{app_vsn}/#{app_name}/#{path}?abc=123&def=456", {}).returns(@good_resp)
    valid_client.request(:get, service, path, test_params)
  end

  def test_post_with_request_params
    service = :some_service
    path = "user"
    @good_resp.stubs(:code).returns(201)

    valid_client._oauth.expects(:post).with("/#{service}/#{app_vsn}/#{app_name}/#{path}", Yajl::Encoder.encode(test_params), "Content-Type" => "application/json").returns(@good_resp)
    valid_client.request(:post, service, path, test_params)
  end

  def test_delete_with_request_params
    service = :a_service
    path = "abc"
    
    valid_client._oauth.expects(:delete).with("/#{service}/#{app_vsn}/#{app_name}/#{path}?something=123", {}).returns(@good_resp)
    valid_client.request(:delete, service, path, something: "123")
  end

  def test_put_with_request_params
    service = :some_service
    path = "abc"
    
    valid_client._oauth.expects(:put).with("/#{service}/#{app_vsn}/#{app_name}/#{path}", Yajl::Encoder.encode(test_params), "Content-Type" => "application/json").returns(@good_resp)
    valid_client.request(:put, service, path, test_params)
  end

end
