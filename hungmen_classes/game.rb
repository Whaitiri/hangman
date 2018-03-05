class Game # game.rb
  attr_accessor :currentWord
  def initialize(gameNum)
    @gameWon = false
    @playerGuessNum = 3
    @gameNum = gameNum
    @players = []
    @currentWord = self.callWord

    begin
      puts "How many players? 1 or 2" # use a begin/rescue/end
      response = Integer(gets.chomp)
      if response == 1 || response == 2
        response.times do |x|
          puts "What is your name, Player #{x + 1}?"
          playerName = gets.chomp
          playerWordBlanked = @currentWord.map { '_' }
          @players[x] = Player.new(x + 1, playerName, playerWordBlanked, @playerGuessNum.dup)
        end
      else
        raise # retry if response != 1 or if response != 2
      end
    rescue
      puts "Please input the number 1 or 2"
      retry
    end
  end

  def callWord
    wordList = []
    File.open("/usr/share/dict/words").each do |line|
      line = line.strip
      if line.strip.length > 7 or line.strip.length < 3
        next
      elsif line[0].match(/^[A-Z]/)
        next
      else
        wordList << line.strip
      end
    end
    return wordList[rand(0...wordList.count)].split("") #return is implicit here
  end

  def gameLoop #rename this
    @players.each do |player|
      if player.playerGuess < 1
        puts "#{player.playerName} has run out of guesses!"
        next
      end
      processInput = Process_input_from_game.new(self, player)
      processInput.process_input

      if player.playerWord == @currentWord
        puts "#{player.playerName} won!"
        @gameWon = true
        self.summarizeGame
      end
    end
    unless self.checkGuessesLeft || @gameWon
      self.gameLoop
    end
  end

  def guessPrompt(player)
    puts "#{player.playerName}'s turn to guess'; you have #{player.playerGuess} guesses remaining."
    if player.playerGuesses.length > 0
      puts "#{player.playerName}'s previous guesses:"
      player.playerGuesses.each do |guess|
        print "#{guess} "
      end
      puts ""
    end
    puts "#{player.playerWord.join(' ')}"
    print "Input a letter: "
  end

  def checkGuessesLeft
    noCoins = 0
    @players.each do |player|
      if player.playerGuess < 1
        noCoins += 1
      end
    end
    if noCoins >= @players.length
      puts "All players have run out of coins!"
      self.summarizeGame
      return true
    else
      return false
    end
  end

  def summarizeGame
    puts "Summary for Game #{@gameNum}:"
    puts "The word was #{@currentWord.join}"
    @players.each do |player|
      puts "#{player.playerName}'s guesses:"
      player.playerGuesses.each do |guess|
        print "#{guess} "
      end
      puts ""
      puts "#{player.playerName}'s guess was #{player.playerWord.join} with #{player.playerGuess} guesses remaining"
      puts ""
    end
  end

end
