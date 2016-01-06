tcp_server = TCPServer.new(9292)
client = tcp_server.accept

counter = 0

loop do
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

  #process request
  case d['Path']
  when '/'
    puts '/ detected'
    response(client,'/ detected')
  when '/hello'
    puts '/hello detected'
    response(client, "/hello #{counter}")
  when '/datetime'
    puts '/datetime detected'
    response(client, Time.now.strftime('%a, %e %b %Y %H:%M:%S %z'))
  when '/shutdown'
    puts '/shutdown detected'
    response(client, '/shutdown detected')
    exit
  else
    puts "#{d['Path']} is an unknown command"
    response(client, "unknown command, #{d['Path']} detected",STATUS_NOTFOUND)
  end


  #output diagnostic info
  print "\n*********** DEBUG INFO ************\n"

  d.each{|key,val|
    puts "#{key}: #{val}"
  }

end
client.close
