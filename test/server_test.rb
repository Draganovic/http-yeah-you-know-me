# require 'server'
# require 'minitest/pride'
# require 'minitest/autorun'
#
#
# class ServerTest < Minitest::Test
#
#   def test_it_is_a_server_object
#     s = Server.new
#     assert s
#   end
#
# end
require 'minitest/autorun'
require 'minitest/pride'
require 'hurley'
require 'socket'
require './lib/server'
require 'hurley/addressable'


class ServerTest < Minitest::Test

 attr_reader :client

 def setup
   @client = Hurley::Client.new "http://127.0.0.1:9292"
 end

 def test_response
   response = client.get("http://127.0.0.1:9292")
   assert response.success?
   assert_equal "127.0.0.1", client.host
   assert_equal 9292, client.port
 end

end
