require './lib/constants'
require './lib/responder'


class Game
  include Constants
  include Responder

  def initialize
    @start = 0
    reset_game
  end

  def reset_game
    @last_guess = -1
    @num_to_guess = randomize
    @number_of_times_they_guess = 0
  end

  def randomize
    rand(1..21)
  end

  def post_guess(guess)
    @last_guess = guess.to_i
    @number_of_times_they_guess +=1
  end

  def start_game(client, request)
    reset_game
    if request['Verb'].upcase == 'POST'
      @start = 1
      msg = "Good luck! Get ready to play!"
      status = STATUS_OK
    else
      msg = "Expecting POST request only. " + STATUS_NOTFOUND
      status = STATUS_NOTFOUND
    end
    response(client,msg,status)
  end

  def has_game?
    Output.print "has_game? -- @start = #{@start}"
    return @start == 1
  end

  def game_in_progress(client,request)
    if request['Verb'].upcase == 'POST'
      if has_game?
        status = STATUS_FORB
        msg = "A game is in progress. " + STATUS_FORB
      else
        status = STATUS_MOVED
        msg = "No game has started, " + STATUS_MOVED
        @start = 1
        reset_game
      end
    end
    response(client,msg,status)
  end

  def riddler(client,request)
    Output.print "inside riddler"
    if request['Verb'].upcase == 'POST'
      Output.print "inside POST"
      if has_game?
        Output.print "inside has_game? -- yes"
        post_guess(request['guess'])
        msg = "Redirecting to GET /game. " + STATUS_REDIRECT
        status = STATUS_REDIRECT
      else
        Output.print "inside has_game? -- no"
        status = STATUS_MOVED
        msg = "No game has started, " + STATUS_MOVED
      end
    else
      Output.print "inside GET"
      msg = the_game
      status = STATUS_OK
    end
    Output.print "before response"
    response(client,msg,status)
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
