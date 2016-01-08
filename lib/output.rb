require './lib/processor'
require './lib/responder'
require './lib/constants'


class Output

  include Constants
  extend Responder

  DEBUG = true
  def self.print(msg)
    puts msg if DEBUG == true
  end

  def self.validate_time(client)
    response(client, Time.now.strftime('%I:%M %p on %A, %B %e, %Y'))
  end

  def self.hello(client, request)
    response(client, "Hello World #{request}")
  end

  def self.debug_info(client,request)
    response(client, request.collect{ |k,v| "#{k}: #{v}" }.join("\n"))
  end

  def self.turn_off(client,request)
    response(client, "Total Requests : #{request}")
    exit
  end

  def self.destruct(client,request)
    begin
      raise SystemStackError, "Whoops..."
    rescue SystemStackError
      response(client, "#{error.class} : #{error.message}<br>" + error.backtrace.join('<br>'),STATUS_ERROR)
    end
  end

  def self.word_finder(client,request)
    h={};/\?(.*)/ =~ request['Path']; $1.split('&').each{ |v| kv = v.split('='); h[kv[1]] = kv[0] }; h
    msg = ''
    contents = File.readlines('/usr/share/dict/words').map(&:chomp!)
    h.each{ |word,param|
      next unless param.downcase == 'word'
      x = contents.one? {|w| w.downcase == word.downcase}
      if x == true
        msg = msg + "#{word.upcase} is a known word\n"
      else
        msg = msg + "#{word.upcase} is not a known word\n"
      end
    }
    Output.print "msg = #{msg}"
    response(client,msg)
  end



end
