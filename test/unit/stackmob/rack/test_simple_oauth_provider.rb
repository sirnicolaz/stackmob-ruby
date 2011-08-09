require 'helper'
require 'rack/test'

class DummyApp
  def call(env)
    [200, {}, ""]
  end
end

class SimpleOAuthProviderTest < MiniTest::Unit::TestCase
  include Rack::Test::Methods

  def app
    StackMob::Rack::SimpleOAuthProvider.new(DummyApp.new)
  end

  def http_host
    "jordan.panic.int.mob:3000"
  end

  def secret
    "ebfe8b21-9401-421c-9b98-28bd721cf367"
  end

  def valid_oauth_header
    "OAuth realm=\"\", oauth_signature=\"5JXBwMgL7yBrsDbxUCrfmidJ1gU%3D\", oauth_nonce=\"1312914650715662000\", oauth_signature_method=\"HMAC-SHA1\", oauth_consumer_key=\"655b062d-8c36-413d-ac0f-8354ca32c5ad\", oauth_timestamp=\"1312914650\""
  end

  def invalid_oauth_header
    # this header has a slightly altered signature
    "OAuth realm=\"\", oauth_signature=\"5XBwMgL7yBrsDbxUCrfmidJ1gU%3D\", oauth_nonce=\"1312914650715662000\", oauth_signature_method=\"HMAC-SHA1\", oauth_consumer_key=\"655b062d-8c36-413d-ac0f-8354ca32c5ad\", oauth_timestamp=\"1312914650\""
  end

  def setup
    StackMob.stubs(:config).returns("secret" => "ebfe8b21-9401-421c-9b98-28bd721cf367")
  end

  def test_successful_oauth
    get "/", {}, {"HTTP_AUTHORIZATION" => valid_oauth_header, "HTTP_HOST" => http_host}

    assert last_response.ok?, "OAuth Failed When it Shouldn't Have"
  end

  def test_failed_oauth
    get "/", {}, {"HTTP_AUTHORIZATION" => invalid_oauth_header, "HTTP_HOST" => http_host}

    assert !last_response.ok?, "OAuth Suceeded When it Shouldn't Have"
  end

end

