require './constants'
require './responder'
require './output'
#require'parser'
#require 'socket'


class Processor

  include Responder
  include Constants
  #process request
  def initialize
    @counter = 0
    @hello_counter = 0
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
      response(client, "/hello #{@hello_counter}")
    when '/datetime'
      Output.print( '/datetime detected')
      response(client, Time.now.strftime('%I:%M %p on %A, %B %e, %Y'))
    when /^\/word_search*/
      Output.print( '^/word_search* detected')
      #parse path to get the word
      word = request['Path']

      contents = File.readlines('/usr/share/dict/words')
      p contents
      #look up word
      #return a response
    when '/shutdown'
      Output.print( '/shutdown detected')
      # output_shutdown
      response(client, "/Total Requests : #{@counter}")
      exit
    else
      Output.print( "#{request['Path']} is an unknown command")
      # output_unknown(diagnostic)
      response(client, "unknown command, #{request['Path']} detected", STATUS_NOTFOUND)
    end

  end
end
