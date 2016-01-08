require './lib/constants'
require './lib/responder'
require './lib/output'
require './lib/the_game'
require 'pry'


class Processor

  include Responder
  include Constants

  def initialize
    @counter = 0
    @hello_counter = 0
    @game = Game.new
  end

  def process(client,request)
    @counter +=1
    case request['Path']

    when '/start_game'
      @game.start_game(client,request)

    when '/game'
      Output.print('/game detected')
      @game.riddler(client,request)

    when '/new_game'
      @game.game_in_progress(client,request)

    when '/'
      Output.print('/ detected')
      Output.debug_info(client,request)

    when '/hello'
      @hello_counter +=1
      Output.print( '/hello detected')
      Output.hello(client, @hello_counter)

    when '/datetime'
      Output.print( '/datetime detected')
      Output.validate_time(client)

    when /^\/word_search*/
      Output.print( '^/word_search* detected')
      Output.word_finder(client,request)

    when '/force_error'
      Output.destruct(client,request)

    when '/shutdown'
      Output.print( '/shutdown detected')
      Output.turn_off(client, @counter)

    else
      Output.print( "#{request['Path']} is an unknown command")
      response(client, STATUS_NOTFOUND, STATUS_NOTFOUND)
    end
  end

end
