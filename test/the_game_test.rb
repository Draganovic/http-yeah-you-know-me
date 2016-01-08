require 'minitest/autorun'
require 'minitest/pride'
require 'hurley'
require 'socket'
require './lib/the_game'
require 'hurley/addressable'


class GameTest < Minitest::Test
  include Constants

  def setup
    @client = Hurley::Client.new "http://127.0.0.1:9292"
    @game = Game.new
  end

  def test_response
    response = @client.get("http://127.0.0.1:9292")
    assert response.success?
    assert_equal "127.0.0.1", @client.host
    assert_equal 9292, @client.port
  end

  def test_game_has_not_started
    response = @client.post("http://127.0.0.1:9292/start_game")
    assert_match "Good luck! Get ready to play!", response.body
    assert_equal 200, response.status_code #403?
  end

    def test_game_has_already_started
      response = @client.post("http://127.0.0.1:9292/start_game")
      response = @client.post("http://127.0.0.1:9292/new_game")
      assert_equal 403, response.status_code
    end

    def test_start_game_will_not_start_in_GET
      response = @client.get("http://127.0.0.1:9292/start_game")
      assert_equal 404, response.status_code
    end


end
