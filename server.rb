require 'socket'

class Server

tcp_server = TCPServer.new(9292)
client = tcp_server.accept

# puts "Ready for a request"
request_lines = []
while line = client.gets and !line.chomp.empty?
  request_lines << line.chomp
end
 # puts "Got this request:"
puts "Hello World #{request_lines.count}"

end
