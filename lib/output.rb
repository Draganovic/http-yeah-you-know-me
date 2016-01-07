class Output
  #DEBUG = false
  DEBUG = true
  def self.print(msg)
    puts msg if DEBUG == true
  end
end
