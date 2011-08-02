require 'helper'

class StackmobClientTest < MiniTest::Unit::TestCase 
  
  attr_reader :valid_client

  def stub_all_requests(method, resp_obj)
    OAuth::AccessToken.any_instance.stubs(method).returns(resp_obj)    
  end

  def setup
    @valid_client = StackMob::Client.new("http://123.com/", "my_app", 0, "some-valid-test-key", "some-valid-test-secret")
  end

  def test_response_json_parsed
    test_hash = {"a" => 1, "b" => 2}
    good_resp = mock("Net::HTTPResponse")
    good_resp.stubs(:code).returns(200)
    good_resp.stubs(:body).returns(Yajl::Encoder.encode(test_hash))                                 
    stub_all_requests(:get, good_resp)

    assert_equal test_hash, valid_client.request(:get, "/abc")
  end

  def test_requesting_invalid_method_raises_error
    assert_raises StackMob::Client::InvalidRequestMethod do
      valid_client.request(:invalid, "/asd")
    end
  end

  def test_when_resp_code_is_not_200
    failed = mock("Net::HTTPResponse")
    failed.stubs(:code).returns(404)
    stub_all_requests(:get, failed)

    
    assert_raises StackMob::Client::RequestError do
      valid_client.request(:get, "/asd")
    end
  end

  def test_when_json_parsing_will_raise_an_error
    resp_w_invalid_body = mock("Net::HTTPResponse")
    resp_w_invalid_body.stubs(:code).returns(200)
    resp_w_invalid_body.stubs(:body).returns("this is not valid json")
    stub_all_requests(:get, resp_w_invalid_body)

    assert_raises StackMob::Client::BadResponseBody do
      valid_client.request(:get, "/asd")
    end
  end

end
