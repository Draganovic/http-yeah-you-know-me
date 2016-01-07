require './constants'
require './responder'
require './output'
require 'pry'


class Processor

  include Responder
  include Constants

  def initialize
    @counter = 0
    @hello_counter = 0
    @output = Output.new
  end

  def process(client,request)#(response method, diagnostic, client, counter, constant)
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
      @output.word_finder(client,request)
    when '/shutdown'
      Output.print( '/shutdown detected')
      response(client, "Total Requests : #{@counter}")
      exit
    else
      Output.print( "#{request['Path']} is an unknown command")
      response(client, "unknown command, #{request['Path']} detected", STATUS_NOTFOUND)
    end

  end
end
