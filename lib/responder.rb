require './constants'
#require 'parser'
#require 'socket'

module Responder
  include Constants
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
