require 'minitest/autorun'
require 'minitest/pride'
require 'hurley'
require 'socket'
require './lib/web_server'
require 'hurley/addressable'


class WebServerTest < Minitest::Test

 attr_reader :client

 def setup
   @client = Hurley::Client.new "http://127.0.0.1:9292"
 end

 def test_response
   response = @client.get("http://127.0.0.1:9292")
   assert response.success?
   assert_equal "127.0.0.1", @client.host
   assert_equal 9292, @client.port
 end

 def test_for_Invalid_endpoint
   response = @client.get("http://127.0.0.1:9292/troll")
   assert_equal 404, response.status_code
 end

 def test_for_Forbidden_endpoint
  response = @client.post("http://127.0.0.1:9292/new_game")
  assert_equal 403, response.status_code
  end

  def test_for_Successful_endpoint
    response = @client.get("http://127.0.0.1:9292")
    assert_equal 200, response.status_code
  end


end
