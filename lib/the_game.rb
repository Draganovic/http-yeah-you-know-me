require './constants'
require './responder'


class Game

  include Constants
  include Responder

def initialize
  @start = 0
  reset_game
end

def start_game
  @start = 1
  reset_game
  "Good luck! Get ready to play!"
end

def reset_game
  @last_guess = -1
  @num_to_guess = randomize
  @number_of_times_they_guess = 0
end

def randomize
  rand(1..21)
end
=begin
def has_game?
  return @start == 1
end
=end

def has_game?(client,request)
  if request['Verb'].upcase == 'POST'
    if @start == 0
      start_game
      status = STATUS_MOVED
      msg = "A game has started. " + STATUS_MOVED
    else
      status = STATUS_FORB
      msg = "A game is in progress. " + STATUS_FORB  
    end
  end
  response(client,msg,status)
end

def post_guess(guess)
  @last_guess = guess.to_i
  @number_of_times_they_guess +=1
end

def the_game
      msg = "Number of guesses made so far: #{@number_of_times_they_guess}\n"
      if @num_to_guess == @last_guess
        msg = "The number was #{@num_to_guess}! It took you #{@number_of_times_they_guess} guesses to figure it out.\n"
      elsif @num_to_guess < @last_guess
        msg += "Your guess of #{@last_guess} is to high! Try again!\n"
      else
        msg += "Your guess of #{@last_guess} is to low! Try again!\n"
      end

    return msg
end

end
