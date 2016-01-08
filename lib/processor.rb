require './constants'
require './responder'
require './output'
require './the_game'
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
    when '/'
      Output.print('/ detected')
      response(client, request.collect{ |k,v| "#{k}: #{v}" }.join("\n"))

    when '/hello'
      @hello_counter +=1
      Output.print( '/hello detected')
      response(client, "Hello World #{@hello_counter}")

    when '/datetime'
      Output.print( '/datetime detected')
      response(client, Time.now.strftime('%I:%M %p on %A, %B %e, %Y'))

    when /^\/word_search*/
      Output.print( '^/word_search* detected')
      Output.word_finder(client,request)

    when '/start_game'
      if request['Verb'].upcase == 'POST'
        msg = @game.start_game
        status = STATUS_OK
      else
        msg = "unknown Verb"
        status = STATUS_ERROR
      end
      response(client,msg,status)

    when '/game'
      if request['Verb'].upcase == 'POST'
        @game.post_guess(request['guess'])
        msg = "/game"
        status = STATUS_REDIRECT
      else
        msg = @game.the_game
        status = STATUS_OK
      end
      response(client,msg,status)

    when '/new_game'
      @game.game_in_progress(client,request)

    when '/force_error'
      begin
        raise SystemStackError
      rescue SystemStackError => error
        response(client, request.collect{ |k,v| "#{k}: #{v}" }.join("\n"),STATUS_ERROR)
      end

    when '/shutdown'
      Output.print( '/shutdown detected')
      response(client, "Total Requests : #{@counter}")
      exit
    else
      Output.print( "#{request['Path']} is an unknown command")
      response(client, STATUS_NOTFOUND, STATUS_NOTFOUND)
    end
  end

end
