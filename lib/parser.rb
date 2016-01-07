require 'socket'
require './output'

class Parser
  attr_reader :diagnostic

  def initialize
    @client = nil
    @diagnostic = {}	#hash containing request diagnostic info
  end

  def parse(client)
    @client = client

    request_lines = []

    while line = @client.gets and !line.chomp.empty?
      request_lines << line.chomp
    end

    populate_diagnostics(request_lines)

    return request_lines
  end

  #output diagnostic info
  def print_diagnostics
    @diagnostic.each{|key,val|
      puts "#{key}: #{val}"
    }
  end

  def clear_diagnostics
    @diagnostic.clear
  end

  def add_header_data
    if @diagnostic.has_key?'Content-Length'
      data = @client.read(@diagnostic['Content-Length'].to_i)
      if !data.nil? && data.index('=') != nil
         v = data.split('=')
        @diagnostic[v[0].strip] = v[1].strip
      end
    end
  end

  def populate_diagnostics(request_lines)

    #put request into hash '@diagnostic'
    request_lines.each.with_index{ |req,index|
      #print index, " ", req, "\n"
      if index == 0
        (@diagnostic['Verb'], @diagnostic['Path'], @diagnostic['Protocol']) = req.split
      else
        line_elements = req.split(':')
        @diagnostic[line_elements[0].strip] = line_elements[1].strip
      end
    }

    #put header data into hash '@diagnostic'
    add_header_data

    return @diagnostic
  end

end
