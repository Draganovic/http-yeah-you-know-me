require 'socket'

tcp_server = TCPServer.new(9292)
client = tcp_server.accept
counter = 0

puts "Ready for a request"
request_lines = []
while line = client.gets and !line.chomp.empty?
  request_lines << line.chomp
end
  counter +=1

puts "Got this request:"
puts request_lines.inspect
print "\n"

d = {}	#hash containing request diagnostic info

#put request into hash 'd'
request_lines.each.with_index{ |req,index|
	#print index, " ", req, "\n"
	if index == 0
		(d['Verb'], d['Path'], d['Protocol']) = req.split
	else
		line_elements = req.split(':')
		d[line_elements[0].strip] = line_elements[1].strip
	end
}
print "\n*********** DEBUG INFO ************\n"

d.each{|key,val|
	puts "#{key}: #{val}"
}

client.close
