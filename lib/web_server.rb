require 'socket'
require './lib/parser'
require './lib/processor'


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
      request = @parser.parse(client)
      @processor.process(client,@parser.diagnostic)
      @parser.print_diagnostics
      @parser.clear_diagnostics
    end
  end

end
if __FILE__ == $0
server = WebServer.new
end
