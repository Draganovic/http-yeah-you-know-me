require './constants'


module Responder
  include Constants
  def response(client,msg,status=STATUS_OK)
    if status == STATUS_REDIRECT
      time = Time.now.strftime('%I:%M %p on %A, %B %e, %Y')
      response = "<pre>" + msg.to_s + "</pre>"
      output = "<html><head></head><body>#{response}</body></html>"
      headers = ["http/1.1 #{status}",
        "Location: #{msg}\r\n\r\n"].join("\r\n")
        client.puts headers
        client.puts output
    else
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
      end
      client.close
    end

end
