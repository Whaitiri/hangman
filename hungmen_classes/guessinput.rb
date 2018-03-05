class Process_input_from_game
  def initialize(game, player)
    @game = game
    @player = player
  end

  def process_input
    begin
      @game.guessPrompt(@player)
      response = gets.chomp.downcase
      if response == "cheat" #enter cheat for testing
        puts "TESTING ONLY - THE ANSWER IS #{@game.currentWord.join}"
        response = nil

      elsif response == 'exit'
        exit

      elsif response.length > 1 or response =~ /[^a-z]/ or response == ''
        puts "please enter a single letter"
        response = nil

      elsif @player.playerGuesses.include?(response)
        puts "you have already input that letter"
        response = nil

      end
      raise
    rescue
      retry if response == nil
    end
    i = 0
    guessFail = 0
    @game.currentWord.each do |letter|
      if letter == response
        @player.playerWord[i] = letter
      else
        guessFail += 1
      end
      i += 1
    end

    unless @player.playerGuesses.include?(response) # change to unless, remove the else
      @player.playerGuesses << response
    end

    if guessFail >= i
      @player.playerGuess -= 1
      puts "#{@player.playerName}'s guess was incorrect..."
    else
      puts "#{@player.playerName}'s guess was correct!"
    end
    puts "#{@player.playerName}: #{@player.playerWord.join(' ')}"
  end
end
