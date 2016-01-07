require 'socket'
require './parser'
require './processor'



class WebServer

  def initialize
    @parser = Parser.new
    @processor = Processor.new
    loop_server
  end

private

  def loop_server
    tcp_server = TCPServer.new(9292)
    loop do
      client = tcp_server.accept
      #Obtain request
      request = @parser.parse(client)
      #Process request
      @processor.process(client,@parser.populate_diagnostics(client,request))
      #Print diagnostic info
      @parser.print_diagnostics
    end
  end

end

server = WebServer.new
