require 'server'
require 'minitest/pride'
require 'minitest/autorun'


class ServerTest < Minitest::Test

  def test_it_is_a_server_object
    s = Server.new
    assert s
  end

end
