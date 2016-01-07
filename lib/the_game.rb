class Game

def initialize
  @start = 0
  @num_to_guess = rand(1..21)
  @number_of_times_they_guess = 0 #counter method
end

def start_game
  @start = 1
  "Good luck!"
end


def the_game
@number_of_times_they_guess +=1
      "guess the number #{@number_guessed} in order to play"
      if number_to_guess = @number_guessed
        "Lucky Guess!"
      if number_to_guess > @number_guessed
        "Your guess is to high! Try again!"
      else
        "Your guess is to low! Try again!"
      end
    end
    "It took you #{number_of_guesses} to figure it out"
end

end
