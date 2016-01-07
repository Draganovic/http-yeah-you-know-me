require 'socket'

# Server who gets it's diagnostic parsed by
# Parser who simply returns a diagnostic
# Server asks Processor to process:
# client, diagnostic, counter
# Processor processes those arguments using
# Responder module methods
# And Outputter's puts module methods
# And returns a "continue" or "exit"


module Responder

  def response(client,msg,status=STATUS_OK)
    time = Time.now.strftime('%I:%M %p on %A, %B %e, %Y')
    response = "<pre>" + msg.to_s + "</pre>"
    output = "<html><head></head><body>#{response}</body></html>"
    headers = ["http/1.1 #{status}",
      "date: #{time}",
      "server: ruby",
      "content-type: text/html; charset=iso-8859-1",
      "content-length: #{output.length}\r\n\r\n"].join("\r\n")
      client.puts headers
      client.puts output
      client.close
  end
end

class WebServer

# require parser.rb
# require processor.rb
  def initialize
    @tcp_server = TCPServer.new(9292)
    @client = tcp_server.accept
    @request_lines =[]
    @parser = Parser.new
    @processor = Processor.new
  end

  def loop_server

    # loop do
    #   get_diag(diag)
    #   parse_diag(diag)
    #   break if processer(client, diagnostic["path"], counter) == "exit"
    # end
    #
      loop do
        def get_diag
      while line = client.gets and !line.chomp.empty?
        request_lines << line.chomp
      end
    end
    break if processor == "exit"
  end
end


class Parser

  def initialize
    @hello_counter = 0
    @diagnostic = {}
  end

  def parser(diagnostic)
    @diagnostic = {}	#hash containing request diagnostic info
    #put request into hash 'd'
    request_lines.each.with_index{ |req,index|
      #print index, " ", req, "\n"
      if index == 0
        (@diagnostic['Verb'], @diagnostic['Path'], @diagnostic['Protocol']) = req.split
      else
        line_elements = req.split(':')
        @diagnostic[line_elements[0].strip] = line_elements[1].strip
      end
    }
  end
  #output diagnostic info
  def format_processor
    @diagnostic.each{|key,val|
      puts "#{key}: #{val}"
    }
  end
end

class Processor
  include Responder

  STATUS_OK = '200 OK'
  STATUS_MOVED = '301 Moved Permanently'
  STATUS_UNAUTH = '401 Unauthorized'
  STATUS_FORB = '403 Forbidden'
  STATUS_NOTFOUND = '404 Not Found'
  STATUS_ERROR = '500 Internal Server Error'
  #process request
  def initialize
    @counter = 0
    @hello_counter = 0
  def processor#(response method, diagnostic, client, counter, constant)
    case @diagnostic['Path']
    when '/'
      puts '/ detected'
      response(client, @diagnostic.collect{ |k,v| "#{k}: #{v}" }.join("\n"))
    when '/hello'
      @hello_counter +=1
      puts '/hello detected'
      response(client, "/hello #{@hello_counter}")
    when '/datetime'
      puts '/datetime detected'
      response(client, Time.now.strftime('%I:%M %p on %A, %B %e, %Y'))
    when '/shutdown'
      puts '/shutdown detected'
      # output_shutdown
      response(client, "/Total Requests : #{@counter}")
      return "exit"
    else
      puts "#{@diagnostic['Path']} is an unknown command"
      # output_unknown(diagnostic)
      response(client, "unknown command, #{@diagnostic['Path']} detected",STATUS_NOTFOUND)
    end
    counter +=1
  end
end
