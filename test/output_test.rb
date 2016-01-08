require 'minitest/autorun'
require 'minitest/pride'
require 'hurley'
require 'socket'
require './lib/web_server'
require './lib/processor'
require './lib/responder'
require './lib/constants'
require 'hurley/addressable'


class OutputTest < Minitest::Test


  def test_validate_time_with_proper_format

    assert_equal Time.now.strftime('%I:%M %p on %A, %B %e, %Y'))
  end

  def test_hello_counter
end
