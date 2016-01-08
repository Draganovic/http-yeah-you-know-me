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
  include Constants

  def setup
    @client = Hurley::Client.new "http://127.0.0.1:9292"
  end

  def test_response
    response = @client.get("http://127.0.0.1:9292")
    assert response.success?
    assert_equal "127.0.0.1", @client.host
    assert_equal 9292, @client.port
  end

  def test_validate_time_with_proper_format
    response = @client.get("http://127.0.0.1:9292/datetime")
    assert_match Time.now.strftime('%I:%M %p on %A, %B %e, %Y'), response.body, ""
    assert_equal 200, response.status_code
  end

  def test_hello_counter
    response = @client.get("http://127.0.0.1:9292/hello")
    assert_match "Hello World 1", response.body
    assert_equal 200, response.status_code
    response = @client.get("http://127.0.0.1:9292/hello")
    assert_match "Hello World 2", response.body
    assert_equal 200, response.status_code
    response = @client.get("http://127.0.0.1:9292/hello")
    assert_match "Hello World 3", response.body
    assert_equal 200, response.status_code
  end

  def test_debug_info_executes
    data = "Verb: GET\nPath: /\nProtocol: HTTP/1.1\n"
    response = @client.get("http://127.0.0.1:9292/")
    assert_match data, response.body
    assert_equal 200, response.status_code
  end

  def test_word_finder_in_dictionary
    response = @client.get("http://127.0.0.1:9292/word_search?word=troll")
    assert_match "TROLL is a known word", response.body
    assert_equal 200, response.status_code
  end

  def test_word_finder_in_dictionary_is_not_case_sensitive
    response = @client.get("http://127.0.0.1:9292/word_search?word=TrOlL")
    assert_match "TROLL is a known word", response.body
    assert_equal 200, response.status_code
  end

  def test_word_finder_not_in_dictionary
    response = @client.get("http://127.0.0.1:9292/word_search?word=TrOlLiee")
    assert_match "TROLLIEE is not a known word", response.body
    assert_equal 200, response.status_code
  end

  # def test_word_finder_in_dictionary_can_find_more_then_one_word
  #   @client.request_options.query_class = Hurley::Query::Flat
  #   response = @client.get("http://127.0.0.1:9292/word_search?word=Trolliee&word=Troll&word=Goblin")
  #   assert_match "TROLLIEE is not a known word", response.body
  #   assert_match "TROLL is a known word", response.body
  #   assert_match "GOBLIN is a known word", response.body
  #   assert_equal 200, response.status_code
  # end



  # def test_self_destruct_works
  #   response = @client.get("http://127.0.0.1:9292/force_error")
  #   assert_equal 500, response.status_code
  # end
end
