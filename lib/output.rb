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
    @word = request['Path'].split("=")[1]
    contents = File.readlines('/usr/share/dict/words').map(&:chomp!)
    x = contents.one? {|w| w == @word}
    p x
    if x == true
    response(client, "#{@word.upcase} is a known word")
    else
    response(client, "#{@word.upcase} is not a known word")
    end
  end

end
