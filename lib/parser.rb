require 'socket'

class Parser

  def initialize
    @diagnostic = {}	#hash containing request diagnostic info
  end

  def parse(client)
    request_lines = []
    while line = client.gets and !line.chomp.empty?
      request_lines << line.chomp
    end

    populate_diagnostics(client,request_lines)

    data = client.read(@diagnostic['Content-Length'].to_i)
    p data
    return request_lines
  end
  #output diagnostic info
  def print_diagnostics
    @diagnostic.each{|key,val|
      puts "#{key}: #{val}"
    }
  end

  def populate_diagnostics(client,request_lines)
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
=begin
    if @diagnostic.has_key?'Content-Length'
      data = client.read(@diagnostic['Content-Length'].to_i)
      if data.index('=') != nil
         v = data.split('=')
         p v
        #@diagnostic[key] = val
      end
    end
=end
    return @diagnostic
  end

end
