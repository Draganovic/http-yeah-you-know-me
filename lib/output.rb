require './processor'
require './responder'

class Output

  #attr_accessor :word_finder
  #include Responder
  extend Responder

  DEBUG = true
  def self.print(msg)
    puts msg if DEBUG == true
  end

  def self.word_finder(client,request)
    h={};/\?(.*)/ =~ request['Path']; $1.split('&').each{ |v| kv = v.split('='); h[kv[1]] = kv[0] }; h
    msg = ''
    contents = File.readlines('/usr/share/dict/words').map(&:chomp!)
    h.each{ |word,parm|
      next unless param.downcase == 'word'
      x = contents.one? {|w| w == word}
      if x == true
        msg += "#{word.upcase} is a known word\n"
      else
        msg += "#{word.upcase} is not a known word\n"
      end
    }
    response(client,msg)
  end
end
