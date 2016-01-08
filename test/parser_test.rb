require 'minitest/autorun'
require 'minitest/pride'
require 'hurley'
require 'socket'
require './lib/parser'


class ParserTest < Minitest::Test
  include Constants

  def setup
    @client = Hurley::Client.new "http://127.0.0.1:9292"
  end

  def test_client_is_available
    client = @client.get("http://127.0.0.1:9292")
    assert client.success?
    assert_equal "127.0.0.1", @client.host
    assert_equal 9292, @client.port
  end

  def test_print_diag
    par = Parser.new

    assert par.print_diagnostics.is_a?(Hash)
  end

  def test_it_can_clear_diagnostic
    par = Parser.new

    assert_equal ({}), par.clear_diagnostics
  end

  def test_pop_diagnostic_returns_hash
    par = Parser.new

    assert par.populate_diagnostics(["abcd"]).is_a?(Hash)
  end

end
